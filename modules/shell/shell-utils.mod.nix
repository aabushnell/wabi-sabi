{ mylib, ... }:
let
  system =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        bat
        zoxide
        lsd
        fzf
        btop
        rmtrash
        trash-cli
      ];
    };
in
{
  flake.modules.nixos.shell-utils = system;
  flake.modules.darwin.shell-utils = system;

  flake.modules.home.shell-utils =
    {
      lib,
      options,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkIf mkOrder;

      zoxideInitZsh = pkgs.runCommand "zoxide-init.zsh" { } ''
        ${lib.getExe pkgs.zoxide} init zsh > $out
      '';
      zoxideInitNu = pkgs.runCommand "zoxide-init.nu" { } ''
        ${lib.getExe pkgs.zoxide} init nushell > $out
      '';
    in
    {
      xdg.config.files."bat/config".text = "--theme=gruvbox-dark";

      environment.sessionVariables = {
        # bat
        MANPAGER = "bat --plain";
        PAGER = "bat --plain";
      };

      shell.aliases = {
        # bat
        cat = "bat";
        less = "bat --plain";
        # lsd
        ls = "lsd";
        # rmtrash
        rm = "rmtrash";
        # zoxide
        cd = "z";
      };

      rc.zsh = mkIf (options ? rc.zsh)
        (mkOrder mylib.shell.rcOrder.tools ''
          source ${zoxideInitZsh}
          source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        '');

      rc.nu = mkIf (options ? rc.nu)
        (mkOrder mylib.shell.rcOrder.tools ''
          source ${zoxideInitNu}
        '');
    };
}
