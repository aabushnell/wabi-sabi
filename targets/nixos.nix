args:
with args;
with mylib;
with allTargetAttrs;
let
  base_args = {
    inherit home-manager;
    nixpkgs = nixpkgs-unstable;
  };
in {

  nixosConfigurations = {
    "kizaemon" = lib.nixosSystem {
      system = allTargetAttrs.x86-linux;
      specialArgs = allTargetSpecialArgs.x86-linux;

      modules = attrs.mergeAttrList [
        kizaemon_modules.nixos-modules

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPkgs = true;
          home-manager.users.${globals.username} = {
            imports = kizaemon_modules.home-modules
          };
        }
      ];
    };
  };
}
