#
# Fields:
#   commonModules     modules shared by all hosts
#   roles             named module lists, e.g. roles.server = [ ... ]
#   hosts             individual systems
#
# Per-host fields:
#   class             "nixos" | "darwin"           (required)
#   system            host platform string         (required)
#   user              login user for hjem (default: globals.username)
#
#   modules           module list override
#   extraModules      additional modules appended to `commonModules`
#   systemModules     additional modules that load only `system` facets
#   homeModules       additional modules that load only `home` facets
#   hostModule        path to host data module directory
#
{
  commonModules = [
    "base"

    "unfree"

    "apps"
    "dev"
    "fonts"
    "gh"
    "git"
    "kitty"
    "rust"
    "xdg"

    "direnv"
    "env"
    "nushell"
    "shell-utils"
    "starship"
    "zsh"
  ];

  hosts = {

    kizaemon = {
      class = "nixos";
      system = "x86_64-linux";
      extraModules = [
        "desktop"
        "kde"
        "kizaemon"
        "nvidia"
        "openssh"
        "ssh"
      ];
      hostModule = ./kizaemon;
    };

    miyoshi = {
      class = "darwin";
      system = "aarch64-darwin";
      extraModules = [
        "dock"
        "finder"
        "homebrew"
        "security"
        "sudo"
      ];
      hostModule = ./miyoshi;
    };

  };
}
