## ADDED Requirements

### Requirement: MPD scrolling module
The MPD module SHALL display the currently playing song title with a marquee scroll effect, with play/pause/stop status icons.

#### Scenario: Song is playing
- **WHEN** MPD is playing a song
- **THEN** the module shows a play icon followed by the scrolling song title

#### Scenario: Song is paused
- **WHEN** MPD is paused
- **THEN** the module shows a pause icon followed by the scrolling song title

#### Scenario: MPD is stopped
- **WHEN** MPD is stopped or not running
- **THEN** the module shows a stop icon and "Music Off" or is hidden

### Requirement: MPD module is event-driven
The MPD module SHALL use `mpc idle` to sleep between updates, not polling.

#### Scenario: Module does not poll
- **WHEN** no MPD events occur
- **THEN** the module script uses near-zero CPU (sleeping on `mpc idle`)

### Requirement: MPD module click handlers
The MPD module SHALL support click and scroll interactions: click to toggle play/pause, scroll up for next track, scroll down for previous track.

#### Scenario: Click toggles playback
- **WHEN** user clicks the MPD module
- **THEN** MPD toggles between play and pause

#### Scenario: Scroll changes track
- **WHEN** user scrolls up on the MPD module
- **THEN** MPD advances to the next track

### Requirement: MPD heart/favorite module
The MPD module set SHALL include a heart icon module that shows whether the current song is in a favorite playlist.

#### Scenario: Song is favorited
- **WHEN** the current song is in the favorite playlist
- **THEN** the module shows a filled heart icon

#### Scenario: Song is not favorited
- **WHEN** the current song is not in the favorite playlist
- **THEN** the module shows an empty heart icon

### Requirement: Heart toggle on click
Clicking the heart module SHALL toggle the current song's favorite status (add to / remove from playlist).

#### Scenario: Toggle adds to favorites
- **WHEN** user clicks the heart module and song is not favorited
- **THEN** the song is added to the favorite playlist and the icon updates to filled heart

#### Scenario: Toggle removes from favorites
- **WHEN** user clicks the heart module and song is favorited
- **THEN** the song is removed from the favorite playlist and the icon updates to empty heart

### Requirement: MPD module scripts location
All MPD module scripts SHALL live in `data/scripts/` and be synced to `~/.config/waybar/scripts/`.

#### Scenario: Scripts are in correct location
- **WHEN** waybar sync runs
- **THEN** mpd-waybar.sh, is_in_playlist.sh, and mpd-heart-toggle.sh exist in `~/.config/waybar/scripts/`
