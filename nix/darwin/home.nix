{ pkgs, ... }:
{
  home.username = "lucho";
  home.homeDirectory = "/Users/lucho";

  programs.home-manager.enable = true;

  # Zsh integration — source nix-daemon profile
  programs.zsh.initExtra = ''
    # Source nix-daemon profile on macOS
    if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
      . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi
  '';

  # Session environment
  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
    "$HOME/.local/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
  };

  # Direnv with nix-direnv support
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # User-level packages
  home.packages = with pkgs; [
    lazygit
    bat
    eza
    zoxide
    fzf
  ];
}
