{ pkgs, ... }: {

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [ 
    pkgs._1password-gui
    pkgs.btop
    pkgs.firefox
    pkgs.itsycal
    pkgs.kitty
    pkgs.lsd
    pkgs.mkalias
    pkgs.neovim
    pkgs.neofetch
    pkgs.raycast
    pkgs.stats
    pkgs.the-unarchiver
  ];

}
