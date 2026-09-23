{ ... }:
{
  flake.modules.darwin.darwin-finder =
    { ... }:
    {
      system.defaults.finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        NewWindowTarget = "Home";
        FXPreferredViewStyle = "clmv"; # column view
      };
    };
}
