{ self, ... }:
{
  hjemify =
    m:
    if builtins.isAttrs m then
      m // { _class = "hjem"; }
    else
      { _class = "hjem"; imports = [ m ]; };
}
