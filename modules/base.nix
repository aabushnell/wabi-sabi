{ pkgs, username, userfullname, ... }: {

  users.users."${username}" = {
    name = username;
    description = userfullname.full;
  };

  # base system packages
  environment.systemPackages = with pkgs; [
    # nix utilities
    nh

    # git
    git

    # c/c++
    gcc
    gnumake
    cmake
    pkg-config

    # archives
    zip
    xz
    zstd
    unzip
    p7zip

    # networking
    inetutils
    wget

    # misc
    neofetch
  ];

  # global nix settings
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
  };

}
