{ inputs, ... }:
{
  flake.modules.darwin.homebrew =
    { config, ... }:
    let
      inherit (builtins) attrNames;
    in
    {
      imports = [ inputs.homebrew.darwinModules.nix-homebrew ];

      nix-homebrew = {
        enable = true;
        enableRosetta = true;
        user = config.system.primaryUser;
        taps = {
          "homebrew/homebrew-core" = inputs.homebrew-core;
          "homebrew/homebrew-cask" = inputs.homebrew-cask;
        };
        mutableTaps = false;
      };

      homebrew = {
        enable = true;
        taps = attrNames config.nix-homebrew.taps;
        onActivation = {
          cleanup = "zap";
          autoUpdate = true;
          upgrade = true;
        };
      };
    };
}
