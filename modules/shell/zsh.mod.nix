{ globals, mylib, ... }:
let
  system =
    { pkgs, ... }:
    {
      programs.zsh = {
        enable = true;
        enableGlobalCompInit = false;
      };

      environment.shells = [ pkgs.zsh ];
      users.users.${globals.username}.shell = pkgs.zsh;
    };
in
{
  flake.modules.nixos.zsh = system;
  flake.modules.darwin.zsh = system;

  flake.modules.home.zsh =
    { lib, config, pkgs, ... }:
    let
      inherit (lib) mkOption mkOrder mkMerge mkIf types;
      inherit (pkgs.stdenv.hostPlatform) isDarwin;

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
        # ~/.zshenv
        files.".zshenv".text = ''
          export ZDOTDIR="''${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
        '';

        # ~/.config/zsh/.zprofile
        xdg.config.files."zsh/.zprofile" = mkIf isDarwin {
          text = ''
            . ${config.environment.loadEnv}
          '';
        };

        # ~/.config/zsh/.zshrc
        xdg.config.files."zsh/.zshrc".text = config.rc.zsh;
        rc.zsh = mkMerge [
          (mkOrder mylib.shell.rcOrder.early ''
            zmodload zsh/zprof
          '')

          (mkOrder mylib.shell.rcOrder.core ''
            # --- History ---
            HISTFILE="''${ZDOTDIR:-$HOME}/history"
            HISTSIZE=100000
            SAVEHIST=100000
            setopt EXTENDED_HISTORY INC_APPEND_HISTORY_TIME
            setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS

            # --- Completions ---
            # NOTE: runs on tab only
            fpath+=(
              "''${HOME}/.nix-profile/share/zsh/site-functions"
              "/run/current-system/sw/share/zsh/site-functions"
              "${pkgs.zsh-completions}/share/zsh/site-functions"
            )
            autoload -Uz compinit
            compinit -u -d "''${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
            zmodload zsh/complist

            zstyle ':completion:*' use-cache on
            zstyle ':completion:*' cache-path "''${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
            zstyle ':completion:*' menu select
            zstyle ':completion:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**'
            zstyle ':completion:*' completer _complete _match _approximate
            zstyle ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 )) numeric )'
            zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS:-}"
            zstyle ':completion:*' group-name ""
            zstyle ':completion:*:descriptions' format '[%d]'
            zstyle ':completion:*:warnings' format 'no matches'

            # --- Keybinds ---
            autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
            zle -N up-line-or-beginning-search
            zle -N down-line-or-beginning-search
            bindkey '^[[A' up-line-or-beginning-search
            bindkey '^[OA' up-line-or-beginning-search
            bindkey '^[[B' down-line-or-beginning-search
            bindkey '^[OB' down-line-or-beginning-search
          '')

          (mkOrder mylib.shell.rcOrder.aliases
            (mylib.shell.renderAliases.zsh (config.shell.aliases or { })))

          (mkOrder mylib.shell.rcOrder.late ''
            export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
            source <(${lib.getExe pkgs.fzf} --zsh)

            ZSH_AUTOSUGGEST_STRATEGY=(history)
            ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
            source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

            # must be last loaded plugin
            source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
          '')

          (mkOrder mylib.shell.rcOrder.final ''
            [[ -z "''${ZSH_PROF:-}" ]] || zprof
          '')
        ];
      };
    };
}
