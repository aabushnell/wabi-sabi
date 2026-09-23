{ ... }:
let
  fonts =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
    };
in
{
  flake.modules.nixos.fonts = fonts;
  flake.modules.darwin.fonts = fonts;
}
