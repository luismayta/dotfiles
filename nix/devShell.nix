{ pkgs }:

let
  versions = import ./versions.nix { inherit pkgs; };
in

pkgs.mkShell {
  packages = with pkgs; [
    # Core tools
    git
    zsh
    rsync
    go-task
    fd
    jq
    ripgrep

    # Language toolchains (versioned via versions.nix)
    versions.python
    versions.nodejs
    versions.go
    uv

    # Linters & formatters
    pre-commit
    biome
    shellcheck
    gitleaks
    hadolint
    codespell
    yamllint

    # Templating & generation
    gomplate

    # Build tools
    gcc

    # Container tooling
    docker
  ];

  shell = pkgs.zsh;

  shellHook = ''
    export SHELL="${pkgs.zsh}/bin/zsh"

    echo "⚡ dotfiles devShell loaded"
    echo "   python: ${versions.pythonVersion} ($(${versions.python}/bin/python --version 2>&1))"
    echo "   node:   ${versions.nodeVersion} ($(${versions.nodejs}/bin/node --version 2>&1))"
    echo "   go:     ${versions.goVersion} ($(${versions.go}/bin/go version 2>&1))"
    echo ""
    echo "  Run 'task --list' to see available commands"
  '';
}
