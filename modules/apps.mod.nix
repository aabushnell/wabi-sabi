{ ... }:
let
  shared =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # cross-platform nixpkgs apps
        obsidian
        localsend
        prismlauncher
        _1password-gui
        jetbrains.clion
        jetbrains.idea
        # jetbrains.pycharm
      ];

      nixpkgs.allowedUnfreePackages = [
        "obsidian"
        "1password"
        "clion"
        "idea"
        # "pycharm"
      ];
    };
in
{
  flake.modules.nixos.apps =
    { pkgs, ... }:
    {
      imports = [ shared ];

      environment.systemPackages = with pkgs; [
        firefox
      ];
    };

  flake.modules.darwin.apps =
    { pkgs, ... }:
    {
      imports = [ shared ];

      environment.systemPackages = with pkgs; [
          # darwin-only nixpkgs apps
          itsycal
          stats
          the-unarchiver
          iina
          mkalias
        ];

      nixpkgs.allowedUnfreePackages = [
        "raycast"
        "the-unarchiver"
      ];

      homebrew = {
        brews = [ "mas" ];

        casks = [
          "firefox"
          "anki"
          "balenaetcher"
          "citrix-workspace"
          "microsoft-word"
          "microsoft-powerpoint"
          "private-internet-access"
          "sol"
          "stremio"
          "zoom"
        ];

        masApps = {
          "Calendars" = 608834326;
          "Pixelmator Pro" = 1289583905;
        };
      };

      # stats - disable auto-update
      system.defaults.CustomUserPreferences."eu.exelban.Stats" = {
        "update-interval" = "never";
      };
    };
}
