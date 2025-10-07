let
  hostname = "miyoshi";
in {
  nixpkgs.hostPlatform = "aarch64-darwin";

  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;
}
