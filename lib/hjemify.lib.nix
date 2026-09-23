{ self, ... }:
let
  inherit (builtins) isAttrs removeAttrs;
in
{
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
}
