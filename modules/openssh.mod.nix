{ globals, ... }:
{
  flake.modules.nixos.openssh =
    { ... }:
    {
      services.openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
      };

      users.users.${globals.username}.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIARuTySTotbUM8FuYnslxKzgfwqhWqmhuuJs0h8UK1l7"
      ];
    };
}
