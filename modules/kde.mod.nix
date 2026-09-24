{ ... }:
{
  flake.modules.nixos.kde =
    { pkgs, ... }:
    {
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;

      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      environment.systemPackages = with pkgs; [
        kdePackages.ksshaskpass
        kdePackages.kate
      ];
    };
}
