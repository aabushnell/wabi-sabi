{ globals, ... }:
{
  flake.modules.darwin.dock =
    { ... }:
    {
      system.defaults.dock = {
        autohide = true;
        autohide-delay = 0.24;
        autohide-time-modifier = 1.0;
        showhidden = true;
        mouse-over-hilite-stack = true;
        show-recents = false;
        mru-spaces = false;
        tilesize = 64;
        magnification = false;
        enable-spring-load-actions-on-all-items = true;

        persistent-apps = [
          { app = "/Applications/Nix Apps/kitty.app"; }
          { app = "/System/Applications/TextEdit.app"; }
          { app = "/Applications/Firefox.app"; }
          { app = "/System/Applications/Music.app"; }
          { app = "/System/Applications/Messages.app"; }
        ];

        persistent-others = [
          "/Users/${globals.username}/Documents"
          "/Users/${globals.username}/Downloads"
        ];

        # hot corners: 1 = disabled
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
      };
    };
}
