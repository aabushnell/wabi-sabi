{ self }:
let
  inherit (self.attrsets) mapAttrsToList;
  inherit (self.strings) concatLines escapeShellArg;
in
{
  shell = {
    renderAliases = {
      zsh = aliases:
        aliases
        |> mapAttrsToList (k: v: "alias ${k}=${escapeShellArg v}")
        |> concatLines;

      nu = aliases:
        aliases
        |> mapAttrsToList (k: v: "alias ${k} = ${v}")
        |> concatLines;
    };

    rcOrder = {
      early   = 300;   # env fixes, profiling, pre-init
      hooks   = 400;   # env-mutating hooks
      core    = 500;   # completion, frameworks, plugins
      aliases = 800;   # rendered alias table
      tools   = 1000;  # tool integrations
      late    = 1400;  # syntax highlighting
      final   = 2000;  # absolute last to load
    };
  };
}
