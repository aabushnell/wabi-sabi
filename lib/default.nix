# lib bootstrap
lib:
let
  inherit (lib.attrsets) attrNames genAttrs recursiveUpdate;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.lists) filter foldl' map;
  inherit (lib.strings) concatStringsSep hasSuffix;
in
lib.extend (
  final: prev:
  let
    fragments =
      listFilesRecursive ./.
      |> filter (hasSuffix ".lib.nix")
      |> map (file: {
        inherit file;
        attrs = import file { self = final; };
      });

    mergeOne =
      acc: fragment:
      let
        duplicates = filter
          (name: builtins.hasAttr name acc.seen)
          (attrNames fragment.attrs);
      in
      if duplicates != [] then
        throw "lib: ${toString fragment.file} redefines: ${concatStringsSep ", " duplicates}"
      else
        {
          seen = acc.seen // genAttrs (attrNames fragment.attrs) (_: true);
          attrs = recursiveUpdate acc.attrs fragment.attrs;
        };

    merged = foldl' mergeOne { seen = { }; attrs = { }; } fragments;
  in
  recursiveUpdate prev merged.attrs
)
