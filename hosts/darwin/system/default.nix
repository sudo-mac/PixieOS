{
  imports = [
    ./options.nix
  ];

  users.users.mac.home = "/Users/mac";
  system.primaryUser = "mac";
  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  nix.settings.experimental-features = "nix-command flakes";
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
