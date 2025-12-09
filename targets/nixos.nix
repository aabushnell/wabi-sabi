args:
with args;
with mylib;
with allTargetAttrs;
let
  inherit (args) globals;
  mkSystem = modules_set: lib.nixosSystem {
    system = x86_linux;

    specialArgs = allTargetSpecialArgs.x86_linux // {
      inherit nixpkgs home-manager;
    };

    modules =
      modules_set.nixos-modules
      ++
      [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = {
            inherit mylib;
            inherit (args) globals;
            inherit (globals) username userfullname useremail;
            inherit (allTargetSpecialArgs.x86_linux) nixvim;
          };

          home-manager.users.${username} = {
            imports = modules_set.home-modules;
          };
        }
      ];
  };

in {
  nixosConfigurations = {
    "kizaemon" = mkSystem kizaemon_modules;
  };
}
