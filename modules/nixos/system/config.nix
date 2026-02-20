{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  # Enabling Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Razer peripherals
  hardware.openrazer.enable = true;

  # Enable USBmuxd
  services.usbmuxd.enable = true;

  # Enable networking
  networking.networkmanager = {enable = true;};

  # Enable Bluetooth
  services.blueman.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        AutoEnable = true;
        FastConnectable = true;
      };
    };
  };

  # Enable Flatpak
  services.flatpak.enable = true;

  #Enable Zsh System-wide
  programs.zsh.enable = true;

  # Force Plasma SSh Keypass Instead of GNOME
  programs.ssh.askPassword = "";

  services.gnome.gcr-ssh-agent.enable = false;

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  hardware.sensor.iio.enable = true;

  environment.systemPackages = with pkgs; [
    jq
    inputs.iio-hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  boot.kernelModules = ["usbnet" "cdc_ether"];

  # NixOS Version
  system.stateVersion = "25.11"; # Did you read the comment?
}
