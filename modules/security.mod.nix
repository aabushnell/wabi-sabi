{ ... }:
{
  flake.modules.darwin.security =
    { ... }:
    {
      homebrew.casks = [
        "blockblock"
        "dhs"
        "knockknock"
        "lulu"
        "netiquette"
        "oversight"
        "ransomwhere"
        "reikey"
        "taskexplorer"
      ];
    };
}
