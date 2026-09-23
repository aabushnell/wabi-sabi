{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.flake.modules = mkOption {
    type = with types; lazyAttrsOf (lazyAttrsOf unspecified);
    default = { };
    description = "Facet registry: modules.<class>.<name>.";
  };
}
