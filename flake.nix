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

    themes = {
      url = "github:RGBCube/ThemeNix";
    };

  };

  outputs = inputs@{
    self,
    nixpkgs,
    nix-darwin,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    home-manager,
    themes,
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

      networking.hostName = "miyoshi";

      users.users.aaron = {
        name = "aaron";
	      home = "/Users/aaron";
      };

      system.primaryUser = "aaron";

    };

    miyoshiTheme = themes.custom {
      name = "Miyoshi Gruvbox Theme";
      author = "aaron";
      base00 = "272727";
      base01 = "CC231C";
      base02 = "989719";
      base03 = "D79920";
      base04 = "448488";
      base05 = "B16185";
      base06 = "689D69";
      base07 = "A89983";
      base08 = "928373";
      base09 = "FB4833";
      base0A = "B8BA25";
      base0B = "FABC2E";
      base0C = "83A597";
      base0D = "D3859A";
      base0E = "8EC07B";
      base0F = "EBDBB2";
    };

  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#hecate
    darwinConfigurations."miyoshi" = nix-darwin.lib.darwinSystem {
      specialArgs = { 
        miyoshiTheme = miyoshiTheme;
      };
      modules = [ 
        bahoukan-config

        home-manager.darwinModules.home-manager

        ./modules/home-manager.nix
        ./modules/packages.nix
        ./modules/homebrew.nix

        ./modules/shell.nix

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
