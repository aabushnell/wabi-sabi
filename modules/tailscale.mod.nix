{ ... }:
let
  shared =
  { pkgs, ... }:
  {
    services.tailscale.enable = true;

    environment.systemPackages = [ pkgs.tailscale ];
  }
in
{
  flake.modules.nixos.tailscale =
    { config, ... }:
    {
      imports = [ shared ];

      services.tailscale = {
        openFirewall = true;
        port = 41641;
        useRoutingFeatures = "client";
        extraSetFlags = [ "--ssh" ];
      };

      networking.firewall.trustedInterfaces = [
          config.services.tailscale.interfaceName
      ];
    };

  flake.modules.darwin.tailscale =
    { ... }:
    {
      imports = [ shared ];

      services.tailscale.overrideLocalDns = false;
    };

  flake.modules.home.tailscale =
    { lib, config, ... }:
    let
      inherit (lib) mkOption types;
      cfg = config.rc.tailscale;
    in
    {
      options.rc.tailscale = {
        hosts = mkOption {
          type = types.attrsOf types.str;
          default = { };
          description = ''
            Tailnet nodes (name -> MagicDNS hostname).
          '';
        };

        serves = mkOption {
          type = types.attrsOf (types.submodule {
            options = {
              port   = mkOption { type = types.port; };
              path   = mkOption { type = types.str;  default = "/"; };
              funnel = mkOption { type = types.bool; default = false; };
            };
          });
          default = { };
          description = ''
            Services announced via tailscale serve.
          '';
        };
      };

      config = {
        xdg.config.files."tailscale/hosts.json".text = builtins.toJSON cfg.hosts;
        xdg.config.files."tailscale/serves.json".text = builtins.toJSON cfg.serves;
      };
    };
}
