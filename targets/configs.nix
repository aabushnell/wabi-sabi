{

  kizaemon_modules = {

    nixos-modules = [
      ../hosts/kizaemon
      ../modules/linux
    ];

    home-modules = [
      ../home/linux
    ];

  };

  miyoshi_modules = {

    darwin-modules = [
      ../hosts/miyoshi
      ../modules/darwin
    ];

    home-modules = [
      # ../hosts/miyoshi/home.nix
      ../home/darwin
    ];

  };

}
