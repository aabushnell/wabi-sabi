{ pkgs, ... }: {

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [ 
    pkgs._1password-gui
    pkgs.bash
    pkgs.cmake
    pkgs.devenv
    pkgs.firefox
    pkgs.fzf
    pkgs.gh
    pkgs.itsycal
    pkgs.jetbrains.clion
    pkgs.jetbrains.idea-ultimate
    pkgs.jetbrains.pycharm-professional
    pkgs.kitty
    pkgs.lsd
    pkgs.mkalias
    pkgs.neovim
    pkgs.neofetch
    pkgs.nh
    pkgs.pkg-config
    pkgs.raycast
    pkgs.stats
    pkgs.the-unarchiver
    pkgs.tree-sitter
    pkgs.uv
    pkgs.zstd
  ];

}
