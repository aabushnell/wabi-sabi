{ pkgs, config, lib, ... }: {

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
      syntaxHighlighting.enable = true;
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
      initContent = lib.mkOrder 1000 ''
        zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
        zstyle ':autocomplete:*history*:*' insert-unambiguous yes
        zstyle ':autocomplete:menu-search:*' insert-unambiguous yes
        zstyle ':completion:*:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**'
      '';
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = lib.concatStrings [
          "[](color_orange)"
          "$os"
          "$username"
          "[](bg:color_yellow fg:color_orange)"
          "$directory"
          "[](fg:color_yellow bg:color_aqua)"
          "$git_branch"
          "$git_status"
          "[](fg:color_aqua bg:color_blue)"
          "$c"
          "$cpp"
          "$rust"
          "$golang"
          "$nodejs"
          "$php"
          "$java"
          "$kotlin"
          "$haskell"
          "$python"
          "[](fg:color_blue bg:color_bg3)"
          "$docker_context"
          "$conda"
          "$pixi"
          "[](fg:color_bg3 bg:color_bg1)"
          "$time"
          "[ ](fg:color_bg1)"
          "$line_break"
          "$character"
        ];
        palette = "gruvbox_dark";
        palettes.gruvbox_dark = {
          color_fg0 = "#fbf1c7";
          color_bg1 = "#3c3836";
          color_bg3 = "#665c54";
          color_blue = "#458588";
          color_aqua = "#689d6a";
          color_green = "#98971a";
          color_orange = "#d65d0e";
          color_purple = "#b16286";
          color_red = "#cc241d";
          color_yellow = "#d79921";
        };
        os = {
          disabled = false;
          style = "bg:color_orange fg:color_fg0";
          symbols = {
            Windows = "󰍲";
            Ubuntu = "󰕈";
            SUSE = "";
            Raspbian = "󰐿";
            Mint = "󰣭";
            Macos = "󰀵";
            Manjaro = "";
            Linux = "󰌽";
            Gentoo = "󰣨";
            Fedora = "󰣛";
            Alpine = "";
            Amazon = "";
            Android = "";
            Arch = "󰣇";
            Artix = "󰣇";
            EndeavourOS = "";
            CentOS = "";
            Debian = "󰣚";
            Redhat = "󱄛";
            RedHatEnterprise = "󱄛";
            Pop = "";
          };
        };
        username = {
          show_always = true;
          style_user = "bg:color_orange fg:color_fg0";
          style_root = "bg:color_orange fg:color_fg0";
          format = "[ $user ]($style)";
        };
        directory = {
          style = "fg:color_fg0 bg:color_yellow";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          substitutions = {
            "Documents" = "󰈙 ";
            "Downloads" = " ";
            "Music" = "󰝚 ";
            "Pictures" = " ";
            "Developer" = "󰲋 ";
          };
        };
        git_branch = {
          symbol = "";
          style = "bg:color_aqua";
          format = "[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)";
        };
        git_status = {
          style = "bg:color_aqua";
          format = "[[($all_status$ahead_behind )](fg:color_fg0 bg:color_aqua)]($style)";
        };
        nodejs = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };
        c = {
          symbol = " ";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };
        cpp = {
          symbol = " ";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };
        rust = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };
        java = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };
        python = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };
        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:color_bg1";
          format = "[[  $time ](fg:color_fg0 bg:color_bg1)]($style)";
        };
        line_break.disabled = false;
        character = {
          disabled = false;
          success_symbol = "[>](bold fg:color_green)";
          error_symbol = "[](bold fg:color_red)";
          vimcmd_symbol = "[](bold fg:color_green)";
          vimcmd_replace_one_symbol = "[](bold fg:color_purple)";
          vimcmd_replace_symbol = "[](bold fg:color_purple)";
          vimcmd_visual_symbol = "[](bold fg:color_yellow)";
        };
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
