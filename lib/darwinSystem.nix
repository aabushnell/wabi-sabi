{
  nixpkgs,
  nix-darwin,
  home-manager,
  nix-homebrew,
  homebrew-core,
  homebrew-cask,
  system,
  specialArgs,
  darwin-modules,
  home-modules
}: let
  inherit (specialArgs) username;
in
  nix-darwin.lib.darwinSystem {
    inherit system specialArgs;
    modules = 
      darwin-modules
      ++ [
        # NOTE: investigate this function
        ({ lib, ... }: {
          nixpkgs.pkgs = import nixpkgs { 
            inherit system; 
            config = {
              allowUnfree = true;
            };
          };

          # nix.registry.nixpkgs.flake = lib.mkForce nixpkgs;

          # environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";

          # nix.nixPath = lib.mkForce ["/etc/nix/inputs"];
          
        })

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = specialArgs;
          # NOTE: check this vs shared modules
          home-manager.users."${username}".imports = home-modules;
        }

        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "${username}";
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };
            mutableTaps = false;
          };
        }
      ];
  }
