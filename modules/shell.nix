{ pkgs, config, ... }: {

  # Set Environment Variables 
  environment.variables = {
    # bat integration
    MANPAGER = "bat --plain";
    PAGER    = "bat --plain";
    # uv
    PATH="/Users/aaron/.local/bin:$PATH";
    # python
    PYTHON_HISTORY="${config.home-manager.users.aaron.xdg.dataHome}/python/history";
    # less
    LESSHISTFILE="${config.home-manager.users.aaron.xdg.stateHome}/less/history";
  };

  # Shell Aliases
  environment.shellAliases = {
    # bat
    cat  = "bat";
    less = "bat --plain";
    # grep
    grep = "grep --color=auto";
    # zoxide
    cd = "z";
    # git
    g = "git";

    ga = "git a"; # git add
    gaa = "git aa"; # git add ./
    gap = "git ap"; # git add -p

    gc = "git commit";
    gcm = "git commit --message";

    gcl = "git clone";

    gd = "git diff";
    gds = "git diff --staged";

    gf = "git fetch";

    gp = "git push";

    gpl = "git pull";

    gs = "git status";
  };

  home-manager.sharedModules = [{

    programs.zsh = {
      enable = true;
      enableCompletion = false;
      # autosuggestion.enable = true;
      dotDir = "${config.home-manager.users.aaron.xdg.configHome}/zsh";
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
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
      ];
      oh-my-zsh = {
        enable = true;
      };
    };

    programs.starship = {
      enable = false;
      settings = {
      };
    };

    programs.direnv = {
      enable = true;
      silent = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

  }]; 

}
