{
  imports = [
    ./options.nix
  ];

  users.users.mac.home = "/Users/mac";
  homebrew.enable = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  system = {
    primaryUser = "mac";
    defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
    defaults.NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
    stateVersion = 6;
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  nix.settings.experimental-features = "nix-command flakes";
}
