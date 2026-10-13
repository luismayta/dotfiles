# freellmapi

> **Service, not a binary:** freellmapi is deployed as a Docker Compose stack.
> The official installer puts nothing on your `PATH` — there is no `freellmapi`
> command to run or complete. Everything in this document manages the service,
> not an executable.

---

## Table of Contents

- [What is freellmapi](#what-is-freellmapi)
- [Requirements](#requirements)
- [Configuration](#configuration)
- [Commands](#commands)
- [Verification Runbook](#verification-runbook)
- [Safety](#safety)
- [Endpoints and Dashboard](#endpoints-and-dashboard)
- [Troubleshooting](#troubleshooting)
- [Uninstall](#uninstall)
- [References](#references)

---

## What is freellmapi

freellmapi is an open-source (MIT, Neu Software LLC) LLM router/proxy that
aggregates the free tiers of ~34-51 providers — Gemini, Groq, Cerebras,
Mistral, OpenRouter and more — behind a single local endpoint. It exposes:

- `/v1` — OpenAI-compatible API
- `/v1/messages` — Anthropic-compatible API
- Ollama emulation — an Ollama-style API
- a web dashboard for managing provider keys

**The key fact: freellmapi is a Docker Compose service, not a binary.** The
official installer (fetched from `ZSH_AI_FREELLMAPI_INSTALL_URL`) installs no
executable in the `PATH`, no shell hook, and no completion. It creates the
compose project directory `${ZSH_AI_FREELLMAPI_DIR}` (default
`${HOME}/freellmapi`), writes `.env` (with the `ENCRYPTION_KEY`) and
`docker-compose.yml`, then pulls the image and starts the stack.

There is nothing to prepend to the `PATH`. That is why
`ai::internal::freellmapi::load` is a deliberate PATH-neutral no-op, and why
the "already installed" guard checks for
`${ZSH_AI_FREELLMAPI_DIR}/docker-compose.yml` on disk instead of a command on
the `PATH`.

---

## Requirements

| Requirement | Needed for | Notes |
|---|---|---|
| Docker daemon running | deploying and running the stack | preflight verifies it with `docker info` |
| `docker compose` plugin (or legacy `docker-compose` binary) | `pull`, `up`, `stop`, `ps`, `logs` | either flavor satisfies preflight |
| `curl` | fetching the official installer, health probes in `install` and `status` | `status` falls back to `compose ps -q` when `curl` is missing |
| `bash` | executing the installer | the installer is piped from `curl` into `bash` |
| `openssl` (optional) | generating the 64-hex `ENCRYPTION_KEY` | the installer falls back to `/dev/urandom` when `openssl` is absent |

---

## Configuration

`config/freellmapi.zsh` exports seven variables:

| Variable | Default | Controls |
|---|---|---|
| `ZSH_AI_FREELLMAPI_PACKAGE_NAME` | `freellmapi` | Tool name, registered in `ZSH_AI_TOOLS` (the install dispatch in `internal/tools.zsh` matches the literal name, not this variable) |
| `ZSH_AI_FREELLMAPI_INSTALL_URL` | `https://freellmapi.co/install.sh` | Official installer fetched by `curl` for both `install` and `upgrade` |
| `ZSH_AI_FREELLMAPI_DIR` | `${HOME}/freellmapi` | Compose project directory: the artifact guard, `status`, and the installer target (passed as `FREELLMAPI_DIR`); holds `.env` and `docker-compose.yml` |
| `ZSH_AI_FREELLMAPI_PORT` | `3001` | Default port; mirrors the upstream `.env` default |
| `ZSH_AI_FREELLMAPI_HOST_BIND` | `127.0.0.1` | Default bind address; mirrors the upstream `.env` default |
| `ZSH_AI_FREELLMAPI_IMAGE` | `ghcr.io/tashfeenahmed/freellmapi:latest` | Pinned container image; mirrors the compose file |
| `ZSH_AI_FREELLMAPI_HEALTH_URL` | `http://127.0.0.1:3001/api/ping` | Health endpoint polled by `install` (up to 60s) and probed by `status` |

These are module defaults assigned when the module loads. To override one,
`export ZSH_AI_FREELLMAPI_...=value` — but set it **after** the module is
sourced (for example, right after the module load in `.zshrc`): the config
file assigns its own value unconditionally at load time, so an export made
before the module loads is replaced by the module default.

Once deployed, `${ZSH_AI_FREELLMAPI_DIR}/.env` is the source of truth for
`PORT` and `HOST_BIND` (the installer is the only writer of `.env`), and
`status` plus the post-install guidance re-read those values from it. If you
change the port or bind address in `.env`, also point
`ZSH_AI_FREELLMAPI_HEALTH_URL` at the same address so the health probe in
`install` and `status` follows along.

---

## Commands

| Command | What it does |
|---|---|
| `ai::freellmapi::install` | Deploy the service (idempotent) |
| `ai::freellmapi::upgrade` | Update the service via the official installer |
| `ai::freellmapi::status` | Report the current state |
| `ai::freellmapi::post_install` | Print the next-step guidance |

### `ai::freellmapi::install`

Deploys the service:

1. **Idempotency guard** — if `${ZSH_AI_FREELLMAPI_DIR}/docker-compose.yml`
   already exists, it prints `freellmapi is already deployed at ... — skipping
   install (.env untouched)` and returns 0. Nothing runs: no preflight, no
   network access, no writes to `.env`.
2. **Preflight** — Docker daemon reachable, compose available, `curl`
   present. Any failure emits a `message_error` and returns non-zero before
   the installer runs.
3. **Official installer** — `curl -fsSL "${ZSH_AI_FREELLMAPI_INSTALL_URL}"`
   piped into `bash` with `FREELLMAPI_DIR="${ZSH_AI_FREELLMAPI_DIR}"` as a
   per-invocation prefix only (never exported into your shell), so the
   deployed directory is exactly the one the guard and `status` inspect.
4. **Health poll** — up to 60s, one `curl --max-time 2` attempt every 2s
   against `ZSH_AI_FREELLMAPI_HEALTH_URL`. If it never answers, you get a
   warning (not an error): `freellmapi deployed, but ... did not answer
   within 60s — it may still be starting; verify with ai::freellmapi::status`.
5. **Success** — `freellmapi installed successfully (compose project: ...)`,
   followed by the post-install guidance.

### `ai::freellmapi::upgrade`

Re-runs the same official installer — re-running it **is** the upstream
update path. It prints `Upgrading freellmapi from ... (.env and
ENCRYPTION_KEY preserved)` and, on success, `freellmapi upgraded successfully
(compose project: ...)`. The installer's idempotency preserves `.env` and its
`ENCRYPTION_KEY`. Preflight applies here too; failures return non-zero.

### `ai::freellmapi::status`

Reports one of three observable states:

| Report | Condition |
|---|---|
| error: `freellmapi is not deployed (no .../docker-compose.yml) — run ai::freellmapi::install` | artifact guard fails |
| success: `freellmapi is running and healthy — dashboard ... (health probe: ...)` | `GET ZSH_AI_FREELLMAPI_HEALTH_URL` answers within 2s |
| warning: `freellmapi is deployed at ... but not responding at ... — inspect with: docker compose -f ... ps and ... logs -f` | guard passes but the health probe fails |

`PORT` and `HOST_BIND` shown in the messages are re-read from `.env`. When
`curl` is missing entirely, `status` falls back to a non-empty
`docker compose -f ... ps -q` as the running signal and says so in its
message (`curl missing: health endpoint not verified`).

### `ai::freellmapi::post_install`

Prints the next-step guidance (also invoked automatically at the end of a
successful `install`): the dashboard URL read back from `.env`, the reminder
to open the dashboard and add provider keys in the Keys section, the client
endpoints `/v1` and `/v1/messages`, and the warning to keep `.env` safe
because losing its `ENCRYPTION_KEY` makes every stored provider key
unrecoverable.

### Batch install (`ai::install`)

`freellmapi` is the last entry of `ZSH_AI_TOOLS`. `ai::install` iterates the
registry and dispatches it through its explicit `freellmapi)` branch in
`internal/tools.zsh` to `ai::internal::freellmapi::install` — it must never
fall through to the generic `core::install` package-manager fallback, which
knows nothing about this tool. Because it sits at the end of the array, the
image pull and the up-to-60s health poll run at the tail of the batch and do
not block the other tools.

---

## Verification Runbook

Full lifecycle check with the five observable states. Requires Docker, the
compose plugin, and `curl`.

```zsh
# --- Pre-state: confirm nothing is deployed yet --------------------------
ls -la "${ZSH_AI_FREELLMAPI_DIR}" 2>&1 || true   # directory does not exist yet
ai::freellmapi::status
# → error: "freellmapi is not deployed (no .../docker-compose.yml) — run ai::freellmapi::install"

# --- 1. install deploys and prints the guidance --------------------------
ai::freellmapi::install
# → "Installing freellmapi from https://freellmapi.co/install.sh"
# → "freellmapi installed successfully (compose project: ...)"
# → guidance: dashboard URL, "open the dashboard and add your provider keys
#    in the Keys section", /v1 + /v1/messages client endpoints,
#    ENCRYPTION_KEY warning

# --- 2. second invocation is a no-op; .env is untouched ------------------
cksum "${ZSH_AI_FREELLMAPI_DIR}/.env" > /tmp/freellmapi.env.cksum
ai::freellmapi::install
# → "freellmapi is already deployed at ... — skipping install (.env untouched)"
cksum "${ZSH_AI_FREELLMAPI_DIR}/.env" | diff - /tmp/freellmapi.env.cksum \
  && echo ".env byte-identical"

# --- 3. status with the service up --------------------------------------
ai::freellmapi::status
# → "freellmapi is running and healthy — dashboard http://127.0.0.1:3001
#    (health probe: http://127.0.0.1:3001/api/ping)"

# --- 4. stop the stack: status reports deployed-but-not-responding -------
docker compose -f "${ZSH_AI_FREELLMAPI_DIR}/docker-compose.yml" stop
ai::freellmapi::status
# → warning: "freellmapi is deployed at ... but not responding at ... —
#    inspect with: docker compose -f ... ps  and  docker compose -f ... logs -f"

# --- 5. upgrade preserves .env byte-for-byte -----------------------------
cksum "${ZSH_AI_FREELLMAPI_DIR}/.env" > /tmp/freellmapi.env.cksum
ai::freellmapi::upgrade
# → "Upgrading freellmapi from ... (.env and ENCRYPTION_KEY preserved)"
# → "freellmapi upgraded successfully (compose project: ...)"
cksum "${ZSH_AI_FREELLMAPI_DIR}/.env" | diff - /tmp/freellmapi.env.cksum \
  && echo ".env byte-identical"
ai::freellmapi::status
# → running and healthy again (the installer re-applies the compose stack)
```

---

## Safety

> **Warning — read before touching `${ZSH_AI_FREELLMAPI_DIR}`:**
>
> - The `ENCRYPTION_KEY` in `${ZSH_AI_FREELLMAPI_DIR}/.env` encrypts your
>   provider keys at rest (AES-256-GCM). **Losing it forces you to re-enter
>   every provider key** — the stored keys are unrecoverable without it.
> - **NEVER** run `docker compose down -v` or `rm -rf ~/freellmapi` unless you
>   want a total wipe: they destroy the `ENCRYPTION_KEY` and the
>   `freellmapi-data` volume. This is not a recoverable operation.
> - To only **stop** the service — preserving absolutely everything
>   (containers, the named volume, **and** `.env`/`ENCRYPTION_KEY`) — use
>   `docker compose -f ~/freellmapi/docker-compose.yml stop`. This is the
>   recommended option when you want to keep your keys.
> - To remove the containers and the network while keeping the named volume:
>   `docker compose -f ~/freellmapi/docker-compose.yml down` (no `-v`).
>   `down` does **not** delete `.env`, so the `ENCRYPTION_KEY` in it is left
>   intact — but it does **not** preserve the containers either.
> - Deleting the project directory is a **key wipe**: `rm -rf ~/freellmapi`
>   removes `.env` and therefore the `ENCRYPTION_KEY`, even though the
>   named volume survives. Do not treat it as a data-safe rollback.
> - The only fully **irrecoverable** scenario is `down -v` **combined with**
>   `rm -rf ~/freellmapi`: you lose the `freellmapi-data` volume **and** the
>   `ENCRYPTION_KEY` at the same time.
> - The module **never writes** `.env` — the official installer is the single
>   writer (a second writer could clobber the `ENCRYPTION_KEY`). That is why
>   `status` and the post-install guidance re-read `PORT`/`HOST_BIND` from
>   `.env` instead of trusting the config defaults.

---

## Endpoints and Dashboard

The dashboard is served at `http://${ZSH_AI_FREELLMAPI_HOST_BIND}:${ZSH_AI_FREELLMAPI_PORT}`
— default `http://127.0.0.1:3001`. After the first install, open it and go to
the **Keys** section to add your provider keys; without keys there is nothing
for the router to route to.

The health endpoint is `GET /api/ping`. It is the same URL used by the
compose healthcheck, by the install health poll, and by
`ai::freellmapi::status`.

Client endpoints (prefix each with the dashboard origin, e.g.
`http://127.0.0.1:3001/v1`):

| Endpoint | API style | Point your client at |
|---|---|---|
| `/v1` | OpenAI-compatible | `${dashboard}/v1` — OpenAI SDKs and any tool that takes an OpenAI base URL |
| `/v1/messages` | Anthropic-compatible | `${dashboard}/v1/messages` — Anthropic SDKs and Claude-style clients |

freellmapi also offers Ollama emulation, so Ollama-shaped clients can talk to
the same router.

---

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `freellmapi preflight: Docker daemon is not reachable (docker info failed)` | Docker daemon is not running | Start Docker (e.g. `sudo systemctl start docker` or Docker Desktop) and retry |
| `freellmapi preflight: neither 'docker compose' nor 'docker-compose' is available` | Compose v2 plugin (or the legacy binary) is missing | Install `docker-compose-plugin` from your distribution, or the standalone `docker-compose` |
| `freellmapi preflight: curl is not installed — required to fetch the official installer` | `curl` is missing | Install `curl` — it is a prerequisite of `install` and `upgrade` |
| `freellmapi is not deployed (no .../docker-compose.yml) — run ai::freellmapi::install` | Nothing deployed yet (or the directory was removed) | Run `ai::freellmapi::install` |
| `freellmapi is deployed at ... but not responding at ...` | Containers stopped or crashed, daemon restarted, or the 60s health poll had not elapsed yet | Run `docker compose -f "${ZSH_AI_FREELLMAPI_DIR}/docker-compose.yml" ps` and then `... logs -f`; the service may just still be starting — re-run `ai::freellmapi::status` |
| `freellmapi deployed, but ... did not answer within 60s` (warning after `install`) | Slow image pull or slow startup | Not fatal — verify with `ai::freellmapi::status`; inspect the logs if it persists |
| `freellmapi installer failed (non-zero exit)` | Network problem or upstream installer error | Re-run `ai::freellmapi::install` — the flow is idempotent and safe to retry |

> **`ai::freellmapi::status` is the primary diagnostic command.** Run it
> first: it tells you which of the three states you are in — not deployed,
> running and healthy, or deployed but not responding.

---

## Uninstall

The module ships no uninstall verb; freellmapi's lifecycle is pure Docker.
Full purge (the upstream uninstall):

```bash
docker compose -f ~/freellmapi/docker-compose.yml down -v && rm -rf ~/freellmapi
```

> **Warning:** this is destructive and irreversible for your provider keys.
> `-v` deletes the `freellmapi-data` volume and `rm -rf` deletes the `.env`
> file that holds the `ENCRYPTION_KEY`, so every stored provider key is lost
> and must be re-entered after any reinstall. To stop or roll back while
> keeping your keys, see [Safety](#safety).

---

## References

| Resource | URL |
|---|---|
| Official site | https://freellmapi.co |
| Source repository (MIT, Neu Software LLC) | https://github.com/tashfeenahmed/freellmapi |
