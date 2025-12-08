{
  self,
  inputs,
  globals
}: let
  inherit (inputs.nixpkgs) lib;
  mylib = import ../lib { inherit lib; };
  configs = import ./configs.nix;

  specialArgsForTarget = system: {
    inherit (globals) username userfullname useremail;
    inherit mylib;

    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    pkgs-stable = import inputs.nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  } // inputs;

  allTargetSpecialArgs = (
    mylib.attrs.mapAttrs
    (_: specialArgsForTarget)
    globals.allTargetAttrs
  );

  args = mylib.attrs.mergeAttrsList [
    inputs
    globals
    configs
    { inherit self lib mylib allTargetSpecialArgs; }
  ];
in
  mylib.attrs.mergeAttrsList [
    (import ./nixos.nix args)
    (import ./darwin.nix args)
  ]
