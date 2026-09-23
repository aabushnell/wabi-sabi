{ mylib, ... }:

{
  flake.modules.home.xdg =
    { config, ... }:
    let
      home = config.directory;
      xdg = config.xdg;
    in
    {
      environment.sessionVariables = {
        XDG_CONFIG_HOME = xdg.config.directory;
        XDG_CACHE_HOME = xdg.cache.directory;
        XDG_DATA_HOME = xdg.data.directory;
        XDG_STATE_HOME = xdg.state.directory;
      };
    };
}
