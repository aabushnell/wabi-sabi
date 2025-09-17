{ pkgs, miyoshiTheme, ... }: {

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.aaron.home = {
      stateVersion = "25.05";
      homeDirectory = "/Users/aaron";
    };
    sharedModules = [{

      programs.bat = {
        enable = true;
        config.theme = "gruvbox-dark";
        themes.miyoshi.src 
          = pkgs.writeText "miyoshi.tmTheme" miyoshiTheme.tmTheme;
      };

      programs.btop.enable = true;

    }];
  };

}
