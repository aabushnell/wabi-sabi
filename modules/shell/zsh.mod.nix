{ globals, mylib, ... }:
let
  system =
    { pkgs, ... }:
    {
      programs.zsh = {
        enable = true;
        enableCompletion = false;
      };

      environment.shells = [ pkgs.zsh ];
      users.users.${globals.username}.shell = pkgs.zsh;
    };
in
{
  flake.modules.nixos.zsh = system;
  flake.modules.darwin.zsh = system;

  flake.modules.home.zsh =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkOption mkOrder mkMerge types;

      zsh-autocomplete = pkgs.fetchFromGitHub {
        owner = "marlonrichert";
        repo = "zsh-autocomplete";
        rev = "25.03.19";
        sha256 = "eb5a5WMQi8arZRZDt4aX1IV+ik6Iee3OxNMCiMnjIx4=";
      };
    in
    {
      options.rc.zsh = mkOption {
        type = types.lines;
        default = "";
        description = "Lines for .zshrc.";
      };

      config = {
        files.".zshenv".text = ''
          export ZDOTDIR="''${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
        '';

        xdg.config.files."zsh/.zshrc".text = config.rc.zsh;

        rc.zsh = mkMerge [
          (mkOrder mylib.shell.rcOrder.early ''
            zmodload zsh/zprof
          '')

          (mkOrder mylib.shell.rcOrder.core ''

            export ZSH_DISABLE_COMPFIX=true
            export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
            source $ZSH/oh-my-zsh.sh

            # zsh-autocomplete: zstyles must be set before sourcing
            zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
            zstyle ':autocomplete:*history*:*' insert-unambiguous yes
            zstyle ':autocomplete:menu-search:*' insert-unambiguous yes
            zstyle ':completion:*:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**'
            source ${zsh-autocomplete}/zsh-autocomplete.plugin.zsh

          '')

          (mkOrder mylib.shell.rcOrder.aliases
            (mylib.shell.renderAliases.zsh (config.shell.aliases or { })))

          (mkOrder mylib.shell.rcOrder.late ''

            source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

          '')

          (mkOrder mylib.shell.rcOrder.final ''
            [[ -z "''${ZSH_PROF:-}" ]] || zprof
          '')
        ];
      };
    };
}
