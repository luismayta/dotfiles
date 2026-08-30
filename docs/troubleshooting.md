---
type: Guide
title: Troubleshooting
description: Common issues and solutions
tags: [troubleshooting, guide]
---

# Troubleshooting

## Environment

### Wrong pre-commit with poetry

Execute the next:

```{.bash}
task environment
```

### Nix daemon connection refused (macOS)

If you see `error: cannot connect to socket at '/nix/var/nix/daemon-socket/socket': Connection refused`, the Nix daemon is not running.

Start the daemon:

```{.bash}
sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist
```

Or restart it:

```{.bash}
sudo launchctl stop org.nixos.nix-daemon
sudo launchctl start org.nixos.nix-daemon
```

Verify it's running:

```{.bash}
launchctl list | grep nix
nix --version
```