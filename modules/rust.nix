{ pkgs, ... }: {

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
