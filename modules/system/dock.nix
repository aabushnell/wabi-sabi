{ ... }: {

  system.defaults.dock = {
    # Whether to automatically hide and show the dock
    autohide = true;
    # Sets the speed of the autohide delay (default 0.24)
    autohide-delay = 0.24;
    # Sets the speed of the animation when hiding/showing the Dock
    autohide-time-modifier = 1.0;
    # Whether to make icons of hidden applications tranclucent
    showhidden = true;

    # Enable highlight hover effect for the grid view of a stack in the Dock
    mouse-over-hilite-stack = true;

    # Show recent applications in the dock
    show-recents = false;
    # Whether to automatically rearrange spaces based on most recent use
    mru-spaces = false;

    # Size of the icons in the dock
    tilesize = 64;
    # Magnify icon on hover
    magnification = false;

    # Enable spring loading for all Dock items
    enable-spring-load-actions-on-all-items = true;

    # Persistent applications, spacers, files, and folders in the dock
    persistent-apps = [
      { app = "/Applications/Nix Apps/kitty.app"; }
      { app = "/System/Applications/TextEdit.app"; }
      { app = "/Applications/Nix Apps/firefox.app"; }
      { app = "/System/Applications/Music.app"; }
      { app = "/System/Applications/Messages.app"; }
    ];

    # Persistent folders in the dock
    persistent-others = [
      "/Users/aaron/Documents"
      "/Users/aaron/Downloads"
    ];

    # Hot corner action [1-14]
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
  };

}
