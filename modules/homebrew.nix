{ config, ... }: {

  homebrew = {

    enable = true;

    brews = [
      "mas"
    ];

    casks = [
      # source: objective-see
      "blockblock"
      # source: citrix systems
      "citrix-workspace"
      # source: objective-see
      "dhs"
      # source: objective-see
      "knockknock"
      # source: objective-see
      "lulu"
      # source: microsoft
      "microsoft-word"
      # source: objective-see
      "netiquette"
      # source: objective-see
      "oversight"
      # source: private internet access
      "private-internet-access"
      # source: objective-see
      "ransomwhere"
      # source: objective-see
      "reikey"
      # source: stremio
      "stremio"
      # source: objective-see
      "taskexplorer"
      # source: cisco systems
      "webex"
    ];

    masApps = {
      "Calendars" = 608834326;
    };

    taps = builtins.attrNames config.nix-homebrew.taps;

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

}
