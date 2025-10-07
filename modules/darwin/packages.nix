{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [ 
    # mac apps
    itsycal
    raycast
    stats
    the-unarchiver

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

    # dev
    jdk
    nodejs
    uv
  ];

}
