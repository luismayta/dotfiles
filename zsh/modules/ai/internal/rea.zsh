# shellcheck shell=bash
# rea internal layer — REA (Reverse Engineer Anything) CLI lifecycle
#
# Design contract (openspec/changes/add-rea-tool/design.md):
#   D2 — the load guard keys on file existence inside ${ZSH_AI_REA_BIN_PATH},
#        never on `core::exists rea`: the upstream installer drops the binary
#        into a directory that is not necessarily on PATH yet, so a
#        `command -v` probe would keep it unreachable in the first shell.
#   D3 — the Node.js engine gate is a pure helper, so the whole major/minor
#        matrix is testable without touching the host runtime.
#   D4 — install order: already-installed guard, Node gate, method dispatch
#        (npm | bun | curl) with per-method prerequisites (npm additionally
#        runs a global-prefix preflight), installer status, PATH effectiveness
#        with a reachability check, then guidance.
#   D5 — skill installation and refresh is delegated to `rea setup`.
#
# Every user-facing message goes through message_info / message_success /
# message_warning / message_error. message_error itself returns 0, so every
# failure branch returns 1 explicitly.

# === PATH Loading ===

function ai::internal::rea::load {
    # D2: guard on file existence, not on `core::exists rea`. The binary
    # lands in ${ZSH_AI_REA_BIN_PATH} (~/.local/bin for the upstream
    # installer), which is usually not on PATH yet — `command -v rea` would
    # fail and the freshly installed binary would stay unreachable. The
    # case-membership test keeps re-sourcing idempotent: PATH never grows a
    # duplicate entry, and a machine without rea keeps PATH untouched.
    [[ -e "${ZSH_AI_REA_BIN_PATH}/rea" ]] || return 0
    case ":${PATH}:" in
        *":${ZSH_AI_REA_BIN_PATH}:"*) ;;
        *) export PATH="${ZSH_AI_REA_BIN_PATH}:${PATH}" ;;
    esac
    return 0
}

# === Node.js Runtime Gate ===

function ai::internal::rea::node_version_supported {
    # Usage: ai::internal::rea::node_version_supported <version>
    # Pure predicate (D3): takes an explicit version string such as
    # "v24.11.0" and returns 0 when REA's engine range accepts it, 1
    # otherwise. Accepted: ^22.19.0 || ^24.11.0 || >=26.0.0.
    # Rejected: 23.x, 25.x, and anything below 22.19.0 / 24.11.0.
    # Only major and minor drive the verdict, so a prerelease or distro
    # suffix ("v24.11.0-pre") is ignored.
    local version="${1:-}"
    local major minor rest

    [[ -n "${version}" ]] || return 1

    version="${version#v}"
    major="${version%%.*}"
    if [[ "${version}" == *.* ]]; then
        rest="${version#*.}"
        minor="${rest%%.*}"
    else
        minor=0
    fi

    # Guard the arithmetic against non-numeric input so a malformed version
    # never raises a math-expression error in the user's shell.
    [[ "${major}" =~ ^[0-9]+$ ]] || return 1
    [[ "${minor}" =~ ^[0-9]+$ ]] || return 1

    (( major == 22 && minor >= 19 )) || (( major == 24 && minor >= 11 )) || (( major >= 26 ))
}

function ai::internal::rea::node_check {
    # Runtime gate: node must exist AND satisfy the engine range. The gate
    # reports incompatibility, it never installs a runtime.
    local msg
    local version

    if ! core::exists node; then
        msg="Node.js is a missing prerequisite for rea — install Node.js (^22.19.0 || ^24.11.0 || >=26.0.0) and re-run"
        message_error "${msg}"
        return 1
    fi

    version="$(node -v 2>/dev/null)"

    if ! ai::internal::rea::node_version_supported "${version}"; then
        msg="unsupported Node.js version ${version:-unknown} — rea requires ^22.19.0 || ^24.11.0 || >=26.0.0 (23.x and 25.x are not supported)"
        message_error "${msg}"
        return 1
    fi

    return 0
}

# === Tool Install ===

function ai::internal::rea::install_via_curl {
    # Shared installer path: the `curl` method and the npm fallback for an
    # immutable global prefix both run the upstream installer.
    # `--no-setup` keeps the installer non-interactive — upstream would
    # otherwise launch the interactive setup wizard (including the Hopper
    # prompt) on a TTY. Setup stays owned by `ai::rea::setup` (D5).
    local msg

    if ! core::exists curl; then
        msg="curl is required to run the upstream rea installer but was not found on PATH"
        message_error "${msg}"
        return 1
    fi

    msg="Installing rea with the upstream installer: ${ZSH_AI_REA_INSTALL_URL}"
    message_info "${msg}"
    # pipefail so a failing download is not masked by bash' status.
    setopt localoptions pipefail
    if ! curl -fsSL "${ZSH_AI_REA_INSTALL_URL}" | bash -s -- --version "${ZSH_AI_REA_VERSION}" --no-setup; then
        msg="the upstream rea installer failed (non-zero exit) — re-run ai::rea::install to retry"
        message_error "${msg}"
        return 1
    fi

    return 0
}

function ai::internal::rea::install {
    # Order (D4): (1) already installed → informational early return,
    # (2) Node.js engine gate, (3) method dispatch with the prerequisite of
    # the selected method, (4) installer status, (5) make the binary
    # reachable and verify that it resolves, (6) success message and
    # post-install guidance.
    local msg
    # Mirrors the configured default (config/rea.zsh): curl. The npm and
    # bun branches run only when the user opts into them explicitly.
    local method="${ZSH_AI_REA_INSTALL_METHOD:-curl}"
    local method_label="${method}"
    local install_dir="${ZSH_AI_REA_BIN_PATH:-~/.local/bin}"
    local npm_prefix

    if core::exists rea; then
        msg="rea is already installed — skipping install"
        message_info "${msg}"
        return 0
    fi

    ai::internal::rea::node_check || return 1

    if [[ -z "${ZSH_AI_REA_PACKAGE_SPEC}" ]]; then
        msg="ZSH_AI_REA_PACKAGE_SPEC is not set — check the ai module config (config/rea.zsh)"
        message_error "${msg}"
        return 1
    fi

    case "${method}" in
        npm)
            if ! core::exists npm; then
                msg="npm is required by ZSH_AI_REA_INSTALL_METHOD=npm but was not found on PATH"
                message_error "${msg}"
                return 1
            fi
            # Preflight: an immutable global prefix (a Nix store path, a
            # read-only prefix) cannot receive `npm install --global`. Detect
            # that before the install and fall back to the upstream
            # installer for this run; the default method (curl) is unaffected.
            npm_prefix="$(npm prefix --global 2>/dev/null)"
            if [[ -n "${npm_prefix}" ]] && [[ ! -w "${npm_prefix}" ]]; then
                msg="npm global prefix ${npm_prefix} is not writable — falling back to the upstream curl installer (override with ZSH_AI_REA_INSTALL_METHOD)"
                message_warning "${msg}"
                method_label="curl"
                install_dir="${ZSH_AI_REA_BIN_PATH:-~/.local/bin}"
                ai::internal::rea::install_via_curl || return 1
            else
                msg="Installing rea with npm: ${ZSH_AI_REA_PACKAGE_SPEC}"
                message_info "${msg}"
                if ! npm install --global "${ZSH_AI_REA_PACKAGE_SPEC}"; then
                    msg="npm install --global ${ZSH_AI_REA_PACKAGE_SPEC} failed (non-zero exit)"
                    message_error "${msg}"
                    return 1
                fi
                if [[ -n "${npm_prefix}" ]]; then
                    install_dir="${npm_prefix}/bin"
                else
                    install_dir="the npm global prefix"
                fi
            fi
            ;;
        bun)
            if ! core::exists bun; then
                msg="bun is required by ZSH_AI_REA_INSTALL_METHOD=bun but was not found on PATH"
                message_error "${msg}"
                return 1
            fi
            msg="Installing rea with bun: ${ZSH_AI_REA_PACKAGE_SPEC}"
            message_info "${msg}"
            if ! bun add --global "${ZSH_AI_REA_PACKAGE_SPEC}"; then
                msg="bun add --global ${ZSH_AI_REA_PACKAGE_SPEC} failed (non-zero exit)"
                message_error "${msg}"
                return 1
            fi
            install_dir="$(bun pm bin -g 2>/dev/null)"
            [[ -n "${install_dir}" ]] || install_dir="${ZSH_AI_REA_BIN_PATH:-~/.local/bin}"
            ;;
        curl)
            if ! core::exists curl; then
                msg="curl is required by ZSH_AI_REA_INSTALL_METHOD=curl but was not found on PATH"
                message_error "${msg}"
                return 1
            fi
            method_label="curl"
            install_dir="${ZSH_AI_REA_BIN_PATH:-~/.local/bin}"
            ai::internal::rea::install_via_curl || return 1
            ;;
        *)
            msg="unknown ZSH_AI_REA_INSTALL_METHOD '${method}' — expected one of: npm, bun, curl"
            message_error "${msg}"
            return 1
            ;;
    esac

    # The upstream curl installer drops the binary into
    # ${ZSH_AI_REA_BIN_PATH}; npm and bun install into their own global
    # prefix (bin directory), which the D2 guard does not touch — it only
    # prepends the configured directory, exactly once, and only when the
    # file is really there.
    ai::internal::rea::load

    # The installer exiting zero does not mean `rea` is reachable: npm and
    # bun install outside ${ZSH_AI_REA_BIN_PATH} and neither prefix is
    # guaranteed to be on PATH. An unreachable binary is an incomplete
    # install — say where it landed and return non-zero instead of
    # claiming success.
    if ! core::exists rea; then
        msg="rea was installed but does not resolve on PATH — the ${method_label} method installed it into ${install_dir}; add that directory to PATH or run ai::rea::doctor"
        message_warning "${msg}"
        return 1
    fi

    msg="rea installed successfully (${ZSH_AI_REA_PACKAGE_SPEC})"
    message_success "${msg}"

    ai::internal::rea::post_install
    return 0
}

# === Subcommand Delegates ===

# Skill management is delegated to `rea setup` (D5): upstream owns the
# destination rules — ${ZSH_AI_REA_SKILLS_DIR} (~/.agents/skills) is used
# only when no client is selected, and symlinks are refused — and upstream
# also owns the client-specific MCP registrations. This module implements
# NO skill sync: there is no directory creation, no copy step and no
# mirroring of the skill tree here. Re-running `rea setup` is the refresh
# path and `rea doctor --skill --json` is the validation path.

function ai::internal::rea::setup {
    local msg
    local rc

    if ! core::exists rea; then
        msg="rea is not installed — run ai::rea::install first"
        message_error "${msg}"
        return 1
    fi

    if [[ -t 0 ]]; then
        # Interactive: upstream asks which client to register and installs
        # the skill itself.
        rea setup
    else
        # Non-interactive (batch/CI): skill only, no client-specific writes.
        rea setup --yes --skill
    fi
    rc=$?

    if (( rc != 0 )); then
        msg="rea setup failed (exit ${rc})"
        message_error "${msg}"
        return 1
    fi

    return 0
}

function ai::internal::rea::doctor {
    local msg
    local rc

    if ! core::exists rea; then
        msg="rea is not installed — run ai::rea::install first"
        message_error "${msg}"
        return 1
    fi

    rea doctor "${@}"
    rc=$?

    if (( rc != 0 )); then
        msg="rea doctor reported a problem (exit ${rc})"
        message_error "${msg}"
        return 1
    fi

    return 0
}

function ai::internal::rea::update {
    local msg
    local rc

    if ! core::exists rea; then
        msg="rea is not installed — run ai::rea::install first"
        message_error "${msg}"
        return 1
    fi

    rea update "${@}"
    rc=$?

    if (( rc != 0 )); then
        msg="rea update failed (exit ${rc})"
        message_error "${msg}"
        return 1
    fi

    return 0
}

function ai::internal::rea::uninstall {
    local msg
    local rc

    if ! core::exists rea; then
        msg="rea is not installed — nothing to uninstall"
        message_error "${msg}"
        return 1
    fi

    rea uninstall "${@}"
    rc=$?

    if (( rc != 0 )); then
        msg="rea uninstall failed (exit ${rc})"
        message_error "${msg}"
        return 1
    fi

    return 0
}

# === Post-install Guidance ===

function ai::internal::rea::post_install {
    # Guidance only — message_* helpers are the single output channel.
    # Each text is composed into a local variable first and handed to
    # message_* afterwards, so no long string is inlined into the helper.
    local msg
    local version="${ZSH_AI_REA_VERSION:-}"
    local detected=""
    local actual=""
    local location="${ZSH_AI_REA_BIN_PATH:-~/.local/bin}"
    local cache_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/rea"

    if [[ -z "${version}" ]]; then
        version="${ZSH_AI_REA_PACKAGE_SPEC##*@}"
    fi
    [[ -n "${version}" ]] || version="unknown"

    if core::exists rea; then
        detected="$(rea --version 2>/dev/null)"
        detected="${detected%%$'\n'*}"
        detected="${detected#rea }"
        [[ -n "${detected}" ]] && version="${detected}"
        # Report where the binary actually lives — npm and bun install into
        # their own global prefix, not necessarily ${ZSH_AI_REA_BIN_PATH}.
        actual="$(command -v rea 2>/dev/null)"
        [[ -n "${actual}" ]] && location="${actual}"
    fi

    msg="rea ${version} installed — binary location ${location}"
    message_success "${msg}"

    msg="MCP surface: the rea MCP server exposes the REA analysis tools to your agent (binary inspection, disassembly, decompilation, runtime tracing, patching, report generation)"
    message_info "${msg}"

    msg="MCP prompts: investigate_feature, compare_application_versions, verify_reconstruction, trace_crash, audit_residual_unknowns, prepare_bounded_process_capture"
    message_info "${msg}"

    msg="state: ~/.rea holds the rea state directory; the Hopper cache lives in ${cache_dir}"
    message_info "${msg}"

    msg="skill: reverse-engineer-anything is installed and refreshed by 'rea setup' (installation and refresh are delegated to upstream) — validate it with 'rea doctor --skill --json'"
    message_info "${msg}"

    msg="next step: run ai::rea::doctor for diagnostics"
    message_info "${msg}"

    return 0
}
