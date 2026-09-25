{ mylib, ... }:
let
  system =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        bat
        btop
        fzf
        ncdu
        lsd
        rmtrash
        trash-cli
        zoxide
      ];
    };
in
{
  flake.modules.nixos.shell-utils = system;
  flake.modules.darwin.shell-utils = system;

  flake.modules.home.shell-utils =
    { lib, options, pkgs, ... }:
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
        cat = "bat --paging=never";
        less = "bat --plain";
        c = "bat --style=changes,header-filename,header-filesize,numbers,snip";

        # lsd
        ls = "lsd --group-directories-first";
        l = "lsd --group-directories-first --long";
        ll = "lsd --group-directories-first --long --total-size";
        la = "lsd --group-directories-first --long --almost-all";
        lla = "lsd --group-directories-first --long --total-size --almost-all";
        lt = "lsd --group-directories-first --tree";
        lat = "lsd --group-directories-first --tree --almost-all";
        llt = "lsd --group-directories-first --tree --long --total-size";
        llat = "lsd --group-directories-first --tree --long --total-size --almost-all";

        # rmtrash
        rm = "rmtrash -r";

        # zoxide
        cd = "z";
        cdi = "zi";
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
