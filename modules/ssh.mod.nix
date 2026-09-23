{ ... }:
{
  flake.modules.nixos.ssh =
    { ... }:
    {
      programs.ssh.startAgent = true;
    };

  flake.modules.darwin.ssh =
    { ... }:
    {
      # macos runs its own launchd-managed
      # ssh-agent with SSH_AUTH_SOCK already exported;
      # nothing to start here
    };

  flake.modules.home.ssh =
    { lib, pkgs, ... }:
    lib.mkMerge [
      # kizaemon
      (lib.mkIf pkgs.stdenv.isLinux {
        files.".ssh/config".text = ''
          Host github.com
            HostName github.com
            User git
            IdentityFile ~/.ssh/id_ed25519_GITHUB
            AddKeysToAgent yes
        '';

        environment.sessionVariables = {
          SSH_ASKPASS = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
          SSH_ASKPASS_REQUIRE = "prefer";
        };
      })

      # TODO: miyoshi
      (lib.mkIf pkgs.stdenv.isDarwin {
        # files.".ssh/config".text = ''
        #   ...
        # '';
      })
    ];
}
