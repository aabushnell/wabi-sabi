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
        jetbrains.idea-ultimate
        jetbrains.pycharm-professional
      ];

      nixpkgs.allowedUnfreePackages = [
        "1password-gui"
        "clion"
        "idea-ultimate"
        "pycharm-professional"
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
          raycast
          stats
          the-unarchiver
          iina
          mkalias
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
          "stremio"
          "zoom"
        ];

        masApps = {
          "Calendars" = 608834326;
          "Pixelmator Pro" = 1289583905;
        };
      };
    };
}
