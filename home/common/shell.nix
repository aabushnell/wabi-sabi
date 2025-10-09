{ pkgs, config, lib, ... }: {

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    syntaxHighlighting.enable = true;
    # autosuggestion.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    plugins = [
      # "0000000000000000000000000000000000000000000000000000";
      {
        name = "zsh-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-autocomplete";
          rev = "25.03.19";
          sha256 = "eb5a5WMQi8arZRZDt4aX1IV+ik6Iee3OxNMCiMnjIx4=";
        };
      }
    ];
    oh-my-zsh = {
      enable = true;
    };
    initContent = let
      earlyContent = lib.mkOrder 500 ''
        zmodload zsh/zprof
      '';
      generalContent = lib.mkOrder 1000 ''
        typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
        if [ $(date +'%j') != $updated_at ]; then
          compinit -i
        else
          compinit -C -i
        fi
        zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
        zstyle ':autocomplete:*history*:*' insert-unambiguous yes
        zstyle ':autocomplete:menu-search:*' insert-unambiguous yes
        zstyle ':completion:*:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**'
      '';
      lateContent = lib.mkOrder 1500 ''
        zprof
      '';
      in lib.mkMerge [
        # earlyContent
        generalContent
        # lateContent
      ];
  };

  programs.nushell = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    silent = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

}
