{ ... }:
let
  unfree =
    { config, lib, ... }:
    let
      inherit (lib) mkOption types;
    in
    {
      options.nixpkgs.allowedUnfreePackages = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Unfree package names to allow.";
        example = [
          "nvidia-x11"
          "discord"
        ];
      };

      config.nixpkgs.config.allowUnfreePredicate =
        pkg: lib.elem (lib.getName pkg) config.nixpkgs.allowedUnfreePackages;
    };
in
{
  flake.modules.nixos.unfree = unfree;
  flake.modules.darwin.unfree = unfree;
}
