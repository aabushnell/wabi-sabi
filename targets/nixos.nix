args:
with args;
with mylib;
with allTargetAttrs;
let
  base_args = {
    inherit home-manager;
    inherit nixpkgs-unstable;

    system = x86-linux;
    specialArgs = allTargetSpecialArgs.x86_linux;
  };

mkSystem = modules_set: lib.nixosSystem (
  base_args // {
    modules =
        modules_set.nixos-modules
        ++
        [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            
            home-manager.users.${globals.username} = {
              imports = modules_set.home-modules;
            };
          }
        ];
  }
);
in {

  nixosConfigurations = {
    "kizaemon" = mkSystem kizaemon_modules;
  };
}
