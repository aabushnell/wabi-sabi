
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

{
  commonModules = [
    "base"
    "unfree"
    "theme"
  ];

  hosts = {

    kizaemon = {
      class = "nixos";
      system = "x86_64-linux";
      extraModules = [
        "desktop"
        "kde"
        "nvidia"
      ];
      hostModule = ./kizaemon;
    };

    miyoshi = {
      class = "darwin";
      system = "aarch64-darwin";
      extraModules = [
        "desktop"
        "brew"
      ];
      hostModule = ./miyoshi;
    };

  };
}
