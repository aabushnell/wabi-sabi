{ username, ... }: {

  home = {
    inherit username;
    stateVersion = "25.05";
  };

  xdg.enable = true;

  programs.bat = {
    enable = true;
    config.theme = "gruvbox-dark";
  };

  programs.btop.enable = true;

  programs.lsd = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true; 
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {

      user = {
        name = "Aaron Bushnell";
        email = "aabushnell@gmail.com";
      };

      extraConfig = {
        init.defaultBranch = "main";

        core.autorlf = true;
        core.editor = "nvim";
        core.ignorecase = true;

        "url \"ssh://git@github.com/aabushnell\"" = {
            insteadOf = "https://github.com/aabushnell";
        };
      };

      aliases = {
        a = "add";
        aa = "add ./";
        ap = "add --patch";

        c = "commit";
        cm = "commit --message";

        cl = "clone";

        d = "diff";
        ds = "diff --staged";

        p = "push";

        pl = "pull";

        s = "status";
      };
    };
  };

  programs.delta = {
    enable = true;
    options = {
      diff-so-fancy = true;
      line-numbers = true;
      true-color = "always";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      editor = "nvim";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
    hosts = {
      "github.com" = {
          "users" = {
              "aabushnell" = null;
          };
          "user" = "aabushnell";
        };
    };
  };
}
