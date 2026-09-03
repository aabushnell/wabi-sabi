{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [ 
    # mac apps
    itsycal
    raycast
    stats
    the-unarchiver

    prismlauncher

    obsidian

    localsend

    rmtrash
    trash-cli

    iina

    ##
    aalib

    # shells
    bashInteractive
    zsh
    nushell

    # x-platform apps
    _1password-gui
    # firefox

    jetbrains.clion
    jetbrains.idea-ultimate
    jetbrains.pycharm-professional

    kitty

    # tui
    fzf
    gh
    neovim

    # other utils
    mkalias
    tree-sitter

    # java
    jdk
    maven

    # other dev
    nodejs
    uv
  ];

}
