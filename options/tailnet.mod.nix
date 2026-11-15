{ mylib, ... }:
let
  inherit (mylib) tailnet;

  system =
    { config, lib, ... }:
    let
      inherit (lib) attrNames mkOption types;
    in
    {
      options.my.tailnet.node = mkOption {
        type = types.nullOr (types.enum (attrNames tailnet.mine));
        default = null;
        description = ''
          This host's tailnet identity.
        '';
      };
    };
in
{
  flake.modules.nixos.tailnet =
    { config, lib, ... }:
    let
      inherit (lib) mkIf optional;
      inherit (mylib) tailnet;
      node = config.my.tailnet.node;
    in
    {
      imports = [ system ];

      config = mkIf (node != null) {
        services.tailscale.extraSetFlags =
          optional (tailnet.hasRole "exit-node" node) "--advertise-exit-node";
      };
    };

  flake.modules.darwin.tailnet =
    { config, lib, mylib, ... }:
    let
      inherit (lib) mkIf optional;
      inherit (mylib) tailnet;
      node = config.my.tailnet.node;
    in
    {
      imports = [ system ];

      config = mkIf (node != null) {
        warnings = optional (tailnet.hasRole "exit-node" node) ''
          nix-darwin cannot apply --advertise-exit-node,
          run manually: sudo tailscale set --advertise-exit-node
        '';
      };
    };

  flake.modules.home.tailnet =
    { config, lib, pkgs, ... }:
    let
      inherit (lib) mkOption mkDefault types;

      cfg = config.my.tailscale;
    in
    {
      options.my.tailscale = {
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
        my.tailscale.hosts = mkDefault tailnet.hosts;

        xdg.config.files."tailscale/hosts.json".text = builtins.toJSON cfg.hosts;
        xdg.config.files."tailscale/serves.json".text = builtins.toJSON cfg.serves;
      };
    };
}
