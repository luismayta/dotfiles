{ pkgs, ... }:
{
  # Primary user for system.defaults / home-manager under root activation (nix-darwin >= 25.05)
  system.primaryUser = "luchomayta";

  # Set once at first install; never change without reading darwin-rebuild changelog
  system.stateVersion = 7;

  # Existing macOS account — declared so home-manager can derive username/home
  users.users.luchomayta = {
    name = "luchomayta";
    home = "/Volumes/Data/luchomayta";
  };

  # Nix settings (daemon and build users are managed by nix-darwin)
  nix.settings.experimental-features = "nix-command flakes";

  # Host platform for Apple Silicon
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Touch ID for sudo authentication (renamed option in recent nix-darwin)
  security.pam.services.sudo_local.touchIdAuth = true;

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
