{ pkgs, ... }: {

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [ 
    pkgs._1password-gui
    pkgs.bat
    pkgs.bash
    pkgs.btop
    pkgs.cmake
    pkgs.devenv
    pkgs.firefox
    pkgs.fzf
    pkgs.itsycal
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
    pkgs.uv
    pkgs.zstd
  ];

}
