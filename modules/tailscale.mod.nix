{ mylib, ... }:
let
  shared =
  { pkgs, ... }:
  {
    services.tailscale.enable = true;

    environment.systemPackages = [ pkgs.tailscale ];
  };
in
{
  flake.modules.nixos.tailscale =
    { config, lib, ... }:
    {
      imports = [ shared ];

      services.tailscale = {
        openFirewall = true;
        port = 41641;
        useRoutingFeatures = lib.mkDefault "client";
        extraSetFlags = [ "--ssh" ];
      };

      networking.firewall.trustedInterfaces = [
          config.services.tailscale.interfaceName
      ];
    };

  flake.modules.darwin.tailscale =
    { lib, pkgs, ... }:
    let
      # https://github.com/bestutsengineer/tailscaled-gui-macos/tree/main/tailscaled-exitfix
      exitfix = pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/bestutsengineer/tailscaled-gui-macos/main/tailscaled-exitfix/exitfix.patch";
        hash = "sha256-Ml0Opo3zgmp1R8pIkopmcFxj8WyMTQQxn7jJrfHMNnk=";
      };
    in
    {
      imports = [ shared ];

      services.tailscale.overrideLocalDns = false;

      services.tailscale.package = pkgs.tailscale.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ exitfix ];
      });
    };

  flake.modules.home.tailscale =
    { pkgs, ... }:
    {
      packages = [ (mylib.tailnet.commands.exit pkgs) ];
    };
}
