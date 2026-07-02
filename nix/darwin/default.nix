{ pkgs, ... }:
{
  # Enable nix-daemon and experimental features
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  nix.configureBuildUsers = true;

  # Host platform for Apple Silicon
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Touch ID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # macOS system defaults
  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      show-recents = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    screencapture = {
      location = "~/Pictures/screenshots";
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    git
    zsh
    rsync
    jq
    fd
    ripgrep
    direnv
    glow
    neovim
    nushell
    carapace
  ];
}
