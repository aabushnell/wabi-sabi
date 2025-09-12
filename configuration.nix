{ inputs, pkgs, config, ... }: {
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

  homebrew = {
    enable = true;
    brews = [
      "mas"
    ];
    casks = [
      "blockblock"
      "citrix-workspace"
      "dhs"
      "knockknock"
      "lulu"
      "microsoft-word"
      "netiquette"
      "oversight"
      "private-internet-access"
      "ransomwhere"
      "reikey"
      "stremio"
      "taskexplorer"
    ];
    masApps = {
      "Calendars" = 608834326;
    };
    taps = builtins.attrNames config.nix-homebrew.taps;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

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
