{ mylib, ... }:
let
  shared =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # c/c++ build basics
        gcc
        gnumake

        # java
        jdk

        # js/python
        nodejs
        uv

        # general
        tree-sitter
      ];
    };
in
{
  flake.modules.nixos.dev = shared;
  flake.modules.darwin.dev = shared;

  flake.modules.home.dev =
    {
      lib,
      options,
      config,
      ...
    }:
    let
      inherit (lib) mkIf mkOrder;
    in
    {
      environment.sessionVariables = {
        PYTHON_HISTORY = "${config.xdg.data.directory}/python/history";
      };

      rc.zsh = mkIf (options ? rc.zsh) (mkOrder mylib.shell.rcOrder.tools ''
        export PATH="$HOME/.local/bin:$PATH"
      '');

      rc.nu = mkIf (options ? rc.nu) (mkOrder mylib.shell.rcOrder.tools ''
        $env.PATH = $env.PATH | prepend ($env.HOME + "/.local/bin")
      '');
    };
}

