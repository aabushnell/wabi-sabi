{ self, ... }:
let
  inherit (builtins) isAttrs removeAttrs;

  hjemify =
    m:
    if isAttrs m then
      (removeAttrs m [ "_class" ])
      // {
        _class = "hjem";
        imports = map hjemify (m.imports or [ ]);
      }
    else
      m;
in
{
  inherit hjemify;
}
