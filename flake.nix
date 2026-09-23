{
  description = "wabi-sabi: nix-darwin + nixos system config";

  nixConfig = {
    experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
    show-trace = true;
    warn-dirty = false;
  };

  inputs = {
    # single-channel default
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # general system tools
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "nix-darwin";
      inputs.home-manager.follows = "";
    };

    # darwin system tools
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    # additional flake inputs
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs :
    let
      inherit (inputs.nixpkgs.lib) filter hasSuffix;
      inherit (inputs.nixpkgs.lib.filesystem) listFilesRecursive;

      mylib = import ./lib inputs.nixpkgs.lib;
      globals = import ./globals.nix;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
        _module.args = { inherit mylib globals; };
        perSystem._module.args = { inherit mylib globals; };

        systems = [
          "aarch64-darwin"
          "x86_64-linux"
        ];

        imports = filter (hasSuffix ".mod.nix") (listFilesRecursive ./.);
    };
}
