{ ... }:
{
  flake.modules.darwin.sudo =
    { ... }:
    {
      security.pam.services.sudo_local = {
        enable = true;
        touchIdAuth = true;
      };
    };
}
