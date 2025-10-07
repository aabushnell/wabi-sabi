{ mylib, ... }: {
  # NOTE: check parentheses here
  imports = 
    # modules/darwin/*.nix
    (mylib.collectNix ./.)
    ++ [
      ../base.nix
    ];
}
