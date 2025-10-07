{ mylib, ... }: {
  imports = 
    # home/darwin/*.nix
    (mylib.collectNix ./.)
    ++ [
      # default.nix
      ../common
    ];
}
