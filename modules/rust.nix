{ pkgs, inputs, ... }: {

  nixpkgs.overlays = [ inputs.fenix.overlays.default ];

  environment.systemPackages = [
    
    (pkgs.fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])

  ];
}
