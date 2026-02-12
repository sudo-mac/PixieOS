{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./ssh.nix
    ./stylix.nix
  ];

  environment.systemPackages = with pkgs; [discord sshfs notion-app];

  nixpkgs.config = {
    hostPlatform = "aarch64-darwin";
    allowUnfree = true;
    allowUnsupportedSystem = false;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  homebrew = {
    enable = true;
    casks = ["rustdesk" "qflipper" "firefox" "bambu-studio" "vscodium" "macfuse"];
  };

  users.users.matthew = {
    home = "/Users/matthew";
  };

  system = {
    primaryUser = "matthew";
    configurationRevision = null;
    stateVersion = 6;
  };
}
