{ pkgs, globals, ... }:

{

  imports = [
    ./nvidia.nix
    ./kde.nix
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable sound with pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users.users.${globals.username} = {
    isNormalUser = true;
    description = globals.userfullname.full;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  security.sudo.enable = true;

  environment.systemPackages = with pkgs; [
    gcc
    kitty
    vim
    neovim
    wget
    kdePackages.ksshaskpass
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

}
