{ globals, ... }:
let
  system =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.gh ];
    };
in
{
  flake.modules.nixos.gh = system;
  flake.modules.darwin.gh = system;

  flake.modules.home.gh =
    { pkgs, ... }:
    {
      xdg.config.files."gh/config.yml" = {
        generator = (pkgs.formats.yaml { }).generate "gh-config.yml";
        value = {
          git_protocol = "ssh";
          prompt = "enabled";
          editor = "nvim";
          aliases = {
            co = "pr checkout";
            pv = "pr view";
          };
        };
      };

      xdg.config.files."gh/hosts.yml" = {
        generator = (pkgs.formats.yaml { }).generate "gh-hosts.yml";
        value = {
          "github.com" = {
            user = globals.username;
            users.${globals.username} = null;
          };
        };
      };
    };
}
