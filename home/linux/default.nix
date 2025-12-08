{ mylib, ... }: {
  imports = 
    # home/linux/*.nix
    (mylib.collectNix ./.)
    ++ [
      # Import the shared configuration
      ../common
    ];
}
