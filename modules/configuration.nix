{ inputs, pkgs, config, ... }: {


  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  system.defaults.dock = {
    autohide = true;
    show-recents = false;
  };

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;

    NewWindowTarget = "Home";

    FXPreferredViewStyle = "clmv";
  };

  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
  };
}
