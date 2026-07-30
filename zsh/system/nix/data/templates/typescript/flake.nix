{
  description = "A TypeScript project flake";

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
        name = "typescript-dev";

        packages = with pkgs; [
          nodejs_22
          bun
          typescript
          biome
        ];

        shellHook = ''
          if [[ -f package.json || -f bun.lock ]]; then
            bun install
          fi
        '';
      };
    });

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
  };
}
