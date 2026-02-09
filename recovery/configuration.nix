{ pkgs, modulesPath, ... }: {
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  nixpkgs.hostPlatform = "x86_64-linux";

  environment.systemPackages = with pkgs; [ git neovim networkmanager ];

  networking.networkmanager.enable = true;

  networking.wireless.enable = false;

  systemd.services.NetworkManager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
