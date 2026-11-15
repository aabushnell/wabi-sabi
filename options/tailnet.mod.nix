{ ... }:
let
  system =
    { config, lib, mylib, ... }:
    let
      inherit (lib) attrNames mkIf mkOption optional types;
      inherit (mylib) tailnet;

      join = config.my.tailnet.join;
    in
    {
      options.my.tailnet.join = mkOption {
        type = types.nullOr (types.enum (attrNames tailnet.peers));
        default = null;
        description = ''
          This host's tailnet identity.
        '';
      };

      config = mkIf (join != null) {
        services.tailscale.extraSetFlags =
          optional (tailnet.hasRole "exit-node" join) "--advertise-exit-node";
      };
    };

  home =
    { config, lib, mylib, pkgs, ... }:
    let
      inherit (lib) mkOption mkDefault types;
      inherit (mylib) tailnet;

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
        rc.tailscale.hosts = mkDefault tailnet.hosts;

        xdg.config.files."tailscale/hosts.json".text = builtins.toJSON cfg.hosts;
        xdg.config.files."tailscale/serves.json".text = builtins.toJSON cfg.serves;
      };
    };
in
{
  flake.modules.nixos.tailnet = system;
  flake.modules.darwin.tailnet = system;
  flake.modules.home.tailnet = home;
}
