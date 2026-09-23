{ ... }:
{
  flake.modules.nixos.nvidia =
    { config, ... }:
    {
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false; # proprietary kernel modules
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      # wayland for electron/chromium apps
      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };

      nixpkgs.allowedUnfreePackages = [
        "nvidia-x11"
        "nvidia-settings"
      ];
    };
}
