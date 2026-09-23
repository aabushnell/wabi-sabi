{ ... }:
{
  flake.modules.nixos.desktop =
    { ... }:
    {
      services.xserver.enable = true;

      # pipewire sound
      security.rtkit.enable = true;
      services.pulseaudio.enable = false;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      services.printing.enable = true;
    };
}
