{ mylib, ... }:
let
  system =
    { pkgs, ... }:
    {
      environment.shells = [ pkgs.nushell ];
      environment.systemPackages = [ pkgs.nushell ];
    };
in
{
  flake.modules.nixos.nushell = system;
  flake.modules.darwin.nushell = system;

  flake.modules.home.nushell =
    { lib, config, ... }:
    let
      inherit (lib) mkOption mkOrder mkMerge types;
    in
    {
      options.rc.nu = mkOption {
        type = types.lines;
        default = "";
        description = "Lines for config.nu.";
      };

      config = {
        xdg.config.files."nushell/config.nu".text = config.rc.nu;

        rc.nu = mkMerge [
          (mkOrder mylib.shell.rcOrder.core ''
            $env.config = {
              show_banner: false
            }
          '')
          (mkOrder mylib.shell.rcOrder.aliases
            (mylib.shell.renderAliases.nu (config.shell.aliases or { })))
        ];
      };
    };
}
