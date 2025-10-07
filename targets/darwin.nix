args:
with args;
with mylib;
# NOTE: check if required
with allTargetAttrs;
let 
  base_args = {
    inherit nix-darwin;
    inherit home-manager;
    inherit nix-homebrew homebrew-core homebrew-cask;
    nixpkgs = nixpkgs-unstable;
  };
in {

  darwinConfigurations = {
    "miyoshi" = darwinSystem (
      attrs.mergeAttrsList [
        base_args
        miyoshi_modules
        {
          # NOTE: maybe I can change some system back to target
          system = allTargetAttrs.aarch64_darwin;
          specialArgs = allTargetSpecialArgs.aarch64_darwin;
        }
      ]
    );
  };
}
