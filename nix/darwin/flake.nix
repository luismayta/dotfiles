{
  description = "Luchex's nix-darwin system configuration — macOS packages, Homebrew, and system defaults";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # TODO: [FIX] Migrate to a path outside the repository.
  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }: {
    darwinConfigurations."Osiris" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./default.nix
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.luchomayta = import ./home.nix;
          };
        }
      ];
    };
  };
}