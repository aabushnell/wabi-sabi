{ ... }:
{
  flake.modules.home.env =
    { lib, config, ... }:
    let
      inherit (lib) mkOption types;
    in
    {
      options.shell.aliases = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = ''
          Shell aliases.
          Rendered per shell dialect by the shell facets.
          General aliases defined here;
          facet-specific aliases defined in their files.
        '';
      };

      config = {
        shell.aliases = {
          grep = "grep --color=auto";
        };

        # user-scoped global env vars
        environment.sessionVariables =
          let
            inherit (config.xdg) data state;
          in
          {
            PYTHON_HISTORY = "${data.directory}/python/history";
            LESSHISTFILE = "${state.directory}/less/history";
          };
      };
    };
}
