{ inputs, ... }:
let
  rust =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.fenix.packages.${pkgs.stdenv.hostPlatform.system}.complete.toolchain
      ];
    };
in
{
  flake.modules.nixos.rust = rust;
  flake.modules.darwin.rust = rust;
}
