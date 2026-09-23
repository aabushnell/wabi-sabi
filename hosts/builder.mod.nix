{
  inputs,
  self,
  config,
  lib,
  mylib,
  globals,
  ...
}:
let
  inherit (lib.attrsets) attrByPath mapAttrsToList;
  inherit (lib.lists) concatMap map optional;
  inherit (lib.modules) mkAliasOptionModule;
  inherit (mylib) hjemify;

  manifest = import ./manifest.nix;

  facet =
    class: name:
    attrByPath [ class name ] null self.modules;

  only =
    class: name:
    let
      f = facet class name;
    in
    if f == null then
      throw "manifest: '${name}' has no '${class}' facet"
    else f;

  resolve =
    class: name:
    let
      systemFacet = facet class name;
      homeFacet = facet "home" name;
    in
    if systemFacet == null && homeFacet == null then
      throw "manifest: unknown module '${name}' (no '${class}' or 'home' facet registered)"
    else
      {
        system = optional (systemFacet != null) systemFacet;
        home = optional (homeFacet != null) homeFacet;
      };

  mkHost =
    hostname: spec:
    let
      wanted = map
        (resolve spec.class)
        (spec.modules or (
          manifest.commonModules ++ (
            spec.extraModules or []
        )));

      systemMods =
        concatMap (w: w.system) wanted
        ++ map (only spec.class) (spec.systemModules or []);

      homeMods =
        map hjemify (
          concatMap (w: w.home) wanted
          ++ map (only "home") (spec.homeModules or [])
        );

      hjemBridge =
        optional (homeMods != [ ]) {
          imports = [
            inputs.hjem.${spec.class + "Modules"}.default
            (mkAliasOptionModule [ "home" ] [ "hjem" ])
          ];

          home = {
            clobberByDefault = true;
            users.${spec.user or globals.username}.imports = homeMods;
          };
        };

      builder =
        if spec.class == "nixos" then
          inputs.nixpkgs.lib.nixosSystem
        else
          inputs.nix-darwin.lib.darwinSystem;
    in
    {
      flake.${spec.class + "Configurations"}.${hostname} =
        builder {
          inherit (spec) system;
          specialArgs = { inherit inputs mylib globals; };
          modules = systemMods ++ hjemBridge ++ [
            spec.hostModule
            { networking.hostName = hostname; }
          ];
        };
    };
in
{
  imports = mapAttrsToList mkHost manifest.hosts;
}
