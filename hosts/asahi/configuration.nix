{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./apple-silicon-support
    ];


  # networking.hostName = "nixos"; # Define your hostname.

  networking.networkmanager.enable = true;

  time.timeZone = "Detroit/America";

  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  
   users.users.alice = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; 
   };

   programs.firefox.enable = true;

   environment.systemPackages = with pkgs; [
     neovim
     librewolf
     git
     wget
   ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  system.stateVersion = "25.11"; # Did you read the comment?

}

