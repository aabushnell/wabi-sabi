{ ... }:
let
  envHome =
    { lib, config, ... }:
    let
      inherit (lib) mkOption types;
    in
    {
      options.my.env = {
        fixed = mkOption {
          type = types.attrsOf types.str;
          default = { };
          description = ''
            Fixed env-vars; universal and non-overridable.
          '';
        };
        session = mkOption {
          type = types.attrsOf types.str;
          default = { };
          description = ''
            Session scoped env-vars; overridable by dev shells.
          '';
        };
      };

      config.environment.sessionVariables = config.my.env.session;
    };

  mkCollector = route:
    { lib, config, ... }:
    let
      inherit (lib) foldl' attrValues;
      collect = key:
        foldl' (acc: u: acc // (u.my.env.${key} or { }))
          { }
          (attrValues (config.hjem.users or { }));
    in
    route collect;
in
{
  flake.modules.nixos.env = mkCollector (collect: {
    environment.variables = collect "fixed";
    environment.sessionVariables = collect "session";
  });

  flake.modules.darwin.env = mkCollector (collect: {
    environment.variables = collect "fixed";
  });

  flake.modules.home.env = envHome;
}
