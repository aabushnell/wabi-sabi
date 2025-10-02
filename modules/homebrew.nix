{ config, ... }: {

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
