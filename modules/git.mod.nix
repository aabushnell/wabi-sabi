{ globals, ... }:
let
  system =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        git
        git-lfs
        delta
      ];
    };
in
{
  flake.modules.nixos.git = system;
  flake.modules.darwin.git = system;

  flake.modules.home.git =
    { lib, ... }:
    {
      files.".config/git/config" = {
        generator = lib.generators.toGitINI;
        value = {
          user = {
            name = globals.userfullname.full;
            email = globals.useremail;
          };
          init.defaultBranch = "main";
          core = {
            autocrlf = false;
            editor = "nvim";
            ignorecase = true;
            pager = "delta";
          };
          interactive.diffFilter = "delta --color-only";
          delta = {
            diff-so-fancy = true;
            line-numbers = true;
            true-color = "always";
          };
          filter.lfs = {
            clean = "git-lfs clean -- %f";
            smudge = "git-lfs smudge -- %f";
            process = "git-lfs filter-process";
            required = true;
          };
          url."ssh://git@github.com/aabushnell".insteadOf =
            "https://github.com/aabushnell";
          alias = {
            a = "add";
            aa = "add ./";
            ap = "add --patch";

            c = "commit";
            cm = "commit --message";

            cl = "clone";

            d = "diff";
            ds = "diff --staged";

            p = "push";

            pl = "pull";

            s = "status";
          };
        };
      };
    };
}
