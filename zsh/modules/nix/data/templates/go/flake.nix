{
  description = "A Go project flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, ... }: let
    forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
    pkgsFor = system: import nixpkgs { inherit system; };
  in {
    devShells = forAllSystems (system: let
      pkgs = pkgsFor system;
    in {
      default = pkgs.mkShell {
        name = "go-dev";

        packages = with pkgs; [
          go
          gopls
          golangci-lint
          delve
        ];

        shellHook = ''
          export CGO_ENABLED=1
          unset GOFLAGS
        '';
      };
    });

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
  };
}
