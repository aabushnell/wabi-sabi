{ ... }:
{
  flake.modules.home.vars =
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
      };
    };
}
