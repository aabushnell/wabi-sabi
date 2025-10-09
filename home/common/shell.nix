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
    initContent = lib.mkOrder 1000 ''
      zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
      zstyle ':autocomplete:*history*:*' insert-unambiguous yes
      zstyle ':autocomplete:menu-search:*' insert-unambiguous yes
      zstyle ':completion:*:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**'
    '';
  };

  programs.direnv = {
    enable = true;
    silent = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

}
