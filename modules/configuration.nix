{ inputs, pkgs, config, ... }: {


  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
  };
}
