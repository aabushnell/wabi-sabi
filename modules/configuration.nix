{ inputs, pkgs, config, ... }: {

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
