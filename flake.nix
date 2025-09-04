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

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, zen-browser }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      environment.systemPackages =
        [ 
	  pkgs._1password-gui
	  pkgs.firefox
	  pkgs.itsycal
	  pkgs.kitty
	  pkgs.lsd
	  pkgs.mkalias
	  pkgs.neovim
	  pkgs.neofetch
	  pkgs.raycast
	  pkgs.stats
	  pkgs.the-unarchiver
        ];
	
      homebrew = {
        enable = true;
	brews = [
	  "mas"
	];
	casks = [
	  "blockblock"
	  "citrix-workspace"
	  "dhs"
	  "knockknock"
	  "lulu"
	  "netiquette"
	  "oversight"
	  "private-internet-access"
	  "ransomwhere"
	  "reikey"
	  "stremio"
	  "taskexplorer"
	];
	masApps = {
	};
	onActivation.cleanup = "zap";
	onActivation.autoUpdate = true;
	onActivation.upgrade = true;
      };

      system.defaults = {
        dock.autohide = true;
      };

      system.defaults.finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      networking.hostName = "hecate";

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
    darwinConfigurations."hecate" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 
	nix-homebrew.darwinModules.nix-homebrew
	{
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
