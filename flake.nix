{
  description = "Hecate Darwin System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{
    self,
    nix-darwin,
    nixpkgs,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    zen-browser,
    ...
  }: 
  let
    bahoukan-config = { pkgs, config, ... }: {

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      networking.hostName = "bahoukan";

      users.users.aaron = {
        name = "aaron";
	      home = "/Users/aaron";
      };

      system.primaryUser = "aaron";

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#hecate
    darwinConfigurations."bahoukan" = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs; };
      modules = [ 
        bahoukan-config
        ./modules/packages.nix
        ./modules/homebrew.nix
        ./modules/fonts.nix
        ./modules/system/dock.nix
        ./modules/system/finder.nix
        ./modules/system/sudo.nix
	      nix-homebrew.darwinModules.nix-homebrew {
	        nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "aaron";
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
	          };
	          mutableTaps = false;
	        };
	      }
      ];
    };
  };
} 
