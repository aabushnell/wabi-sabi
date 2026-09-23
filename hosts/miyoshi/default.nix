{ globals, ... }:
let
  hostname = "miyoshi";
in
{
  users.users.${globals.username} = {
    name = globals.username;
    home = "/Users/${globals.username}";
  };

  system.primaryUser = globals.username;
  system.stateVersion = 6;

  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;
}
