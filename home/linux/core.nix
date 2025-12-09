{ pkgs, nixvim, username, ... }: 

{

  imports = [
    nixvim.homeModules.nixvim
    # inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  home.homeDirectory = "/home/${username}";

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
	user = "git";
	identityFile = "~/.ssh/id_ed25519_GITHUB";
	extraOptions = {
	  AddKeysToAgent = "yes";
	};
      };
    };
  };

  services.ssh-agent.enable = true;

  home.sessionVariables = {
    SSH_ASKPASS = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
    SSH_ASKPASS_REQUIRE = "prefer";
  };

}
