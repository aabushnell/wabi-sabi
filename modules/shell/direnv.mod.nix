{ mylib, ... }:
let
  system =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        direnv
        nix-direnv
      ];
    };
in
{
  flake.modules.nixos.direnv = system;
  flake.modules.darwin.direnv = system;

  flake.modules.home.direnv =
    { lib, options, pkgs, ... }:
    let
      inherit (lib) mkIf mkOrder;
    in
    {
      environment.sessionVariables = {
        DIRENV_LOG_FORMAT = "";
      };

      xdg.config.files."direnv/direnvrc".text = ''
        source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
      '';

      rc.zsh = mkIf (options ? rc.zsh)
        (mkOrder mylib.shell.rcOrder.hooks ''
          eval "$(direnv hook zsh)"
        '');

      rc.nu = mkIf (options ? rc.nu)
        (mkOrder mylib.shell.rcOrder.hooks ''
          let direnv_hook = { || direnv export json | from json | default {} | load-env }
          $env.config = ($env.config | upsert hooks.pre_prompt (
            ($env.config.hooks?.pre_prompt? | default []) | append $direnv_hook
          ))
        '');
    };
}
