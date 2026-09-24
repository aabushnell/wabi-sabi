{ inputs, ... }:
let
  configRev = inputs.self.rev or inputs.self.dirtyRev or null;

  base =
    { pkgs, ... }:
    {
      system.configurationRevision = configRev;

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
        auto-optimise-store = true;
      };

      # core packages *ONLY*
      environment.systemPackages = with pkgs; [
        nh
        # temp
        neovim
        #
        git
        curl
        dig
        inetutils
        wget
      ];
    };
in
{
  flake.modules.nixos.base = base;
  flake.modules.darwin.base = base;
}
