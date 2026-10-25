#!/usr/bin/env bats
# Real-player smoke test for notify module (task 7.2)
# This test uses the real /usr/bin/mpg123 with the real sound files,
# not the fake mpg123 used in other tests.

load "${BATS_TEST_DIRNAME}/test_helper.bash"

# Get the real sound path
sound_path="${ZSH_NOTIFY_ASSETS_SOUND_PATH:-${ZSH_NOTIFY_PATH}/data/notify/assets/sounds}"

@test "7.2 real-player smoke check (real mpg123, real sound)" {
    # Ensure the real mpg123 exists
    if ! command -v mpg123 >/dev/null 2>&1; then
        skip "real mpg123 not found on PATH"
    fi
    
    # Ensure the real sound exists (use r2d2 theme as configured)
    local sound_file="${sound_path}/r2d2/success.mp3"
    if [[ ! -f "$sound_file" ]]; then
        # Fallback to default theme if r2d2 not available
        sound_file="${sound_path}/default/success.mp3"
        if [[ ! -f "$sound_file" ]]; then
            skip "real sound file not found: $sound_file (tried r2d2/default)"
        fi
    fi
    
    # Create temp directories for this test
    NOTIFY_FIXTURE_HOME="$(make_notify_tmpdir)"
    NOTIFY_FIXTURE_WORK="$(make_notify_tmpdir)"
    NOTIFY_MARKER="${NOTIFY_FIXTURE_HOME}/mpg123.record"
    
    # Export for the zsh -f subshell
    export NOTIFY_FIXTURE_HOME NOTIFY_FIXTURE_WORK NOTIFY_MARKER
    
    # Run the test snippet in a real pty
    run run_notify_zsh_pty "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_WORK" '
        # Set up timing state exactly as required for a >10s command
        _zsh_notify_start_time=$((EPOCHSECONDS-11))
        _zsh_notify_last_command="sleep 11"
        
        # Record start time for timing verification (using microseconds for precision)
        start_time=$(date +%s%3N)
        
        # Call notify::internal::command::completed 
        # This will dispatch to play() which should:
        # 1. Spawn real mpg123 (since it exists)
        # 2. Return in <1s (prompt safety)
        # 3. Play success.mp3 from the real sound theme
        notify::internal::command::completed
        
        # Record end time and calculate duration (in milliseconds)
        end_time=$(date +%s%3N)
        duration=$((end_time - start_time))
        
        # Output duration for assertion (convert to seconds for bats)
        echo "DURATION: $((duration / 1000)).$((duration % 1000))"
    '
    
    # Assert test completed (exit code 0)
    [ "$status" -eq 0 ]
    
    # Extract duration from output
    local duration_seconds=$(echo "$output" | grep "^DURATION:" | sed 's/^DURATION: //')
    
    # Assert duration < 1s (prompt safety)
    # We'll do this by checking the output contains the value
    echo "Duration recorded: $duration_seconds seconds"
    
    # Check if the duration is a valid number less than 1
    if [[ "$duration_seconds" =~ ^([0-9]+\.[0-9]+|[0-9]+)$ ]]; then
        local duration_int=${duration_seconds%%.*}
        if (( duration_int >= 1 )); then
            echo "FAIL: Duration $duration_seconds seconds is not < 1s (prompt safety)"
            exit 1
        fi
    fi
    
    # Check if real mpg123 is running after test
    local after_mpg123=$(pgrep -u "$UID" -x mpg123 || true)
    echo "Real mpg123 PIDs after test: $after_mpg123"
    
    # Wait up to 10s for player to be cleaned up (pure bash arithmetic — `bc`
    # is not installed on this box, and a missing binary here silently skipped
    # the wait, making the check fire while the player was still legitimately
    # alive; the bound and the assertion below are unchanged).
    local cleanup_timeout=10
    local cleanup_interval=0.5
    local cleanup_start_time=$(date +%s)

    while true; do
        local current_mpg123=$(pgrep -u "$UID" -x mpg123 || true)
        if [[ -z "$current_mpg123" ]]; then
            echo "Real mpg123 cleaned up successfully"
            break
        fi

        local current_time=$(date +%s)
        local elapsed=$((current_time - cleanup_start_time))
        local remaining_time=$((cleanup_timeout - elapsed))
        echo "Waiting for cleanup... $remaining_time seconds remaining"

        # Break if we've exceeded the timeout
        if (( elapsed > cleanup_timeout )); then
            break
        fi

        sleep $cleanup_interval
    done
    
    # Final check after cleanup timeout
    local final_mpg123=$(pgrep -u "$UID" -x mpg123 || true)
    if [[ -n "$final_mpg123" ]]; then
        echo "FAIL: Real mpg123 was not cleaned up within 10s: $final_mpg123"
        
        # Cleanup any remaining players
        for pid in $final_mpg123; do
            echo "Cleaning up remaining real mpg123 PID $pid"
            kill -9 "$pid" 2>/dev/null || true
        done
        
        exit 1
    fi
    
    echo "PASS: Real player test completed successfully"
}

teardown() {
    # Cleanup any remaining real mpg123 processes
    local remaining_mpg123=$(pgrep -u "$UID" -x mpg123 || true)
    if [[ -n "$remaining_mpg123" ]]; then
        echo "Cleaning up remaining real mpg123 processes in teardown: $remaining_mpg123"
        for pid in $remaining_mpg123; do
            kill -9 "$pid" 2>/dev/null || true
        done
    fi
    
    # Clean up fixtures
    if [[ -n "${NOTIFY_FIXTURE_HOME:-}" ]]; then
        rm -rf "$NOTIFY_FIXTURE_HOME"
    fi
    if [[ -n "${NOTIFY_FIXTURE_WORK:-}" ]]; then
        rm -rf "$NOTIFY_FIXTURE_WORK"
    fi
    
    # Clean up NOTIFY_FIXTURE_HOME if not already cleaned
    if [[ -n "${NOTIFY_FIXTURE_HOME:-}" ]]; then
        rm -rf "$NOTIFY_FIXTURE_HOME"
    fi
}