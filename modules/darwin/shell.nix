{ pkgs, config, lib, ... }: {

  # Set Environment Variables 
  # shells
  environment.shells = [
    pkgs.bashInteractive
    pkgs.zsh
    pkgs.nushell
  ];
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
  
    # TODO: finish editing aliases
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

}
