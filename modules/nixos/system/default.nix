{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./users.nix
    # ./bitwarden.nix
    ./nvidia.nix
    ./time-and-date.nix
    ./nextcloud.nix
    ./audio.nix
    ./graphics.nix
    ./gaming.nix
    ./claude.nix
    ./minecraft
    ./roblox.nix
    ./asus.nix
    ./bootloader.nix
    ./virtualisation.nix
    ./libreoffice.nix
    ./qflipper.nix
    ./screen.nix
    ./yazi.nix
    ./rustdesk.nix
    ./rustdesk-secrets.nix
    ./pokemmo.nix
    ./hyprland
  ];

  # Enabling Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Razer peripherals
  hardware.openrazer.enable = true;

  # Enable USBmuxd
  services.usbmuxd.enable = true;

  # Enable networking
  networking.networkmanager = {
    enable = true;
  };

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

  # Allow Unfree Packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    appimage-run
    bat
    brightnessctl
    btop
    curl
    exfatprogs
    fastfetch
    freecad
    gimp
    git
    git-lfs
    gparted
    grim
    gzip
    inkscape
    inputs.iio-hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default
    jq
    kdePackages.ark
    kdePackages.dolphin
    libimobiledevice
    lolcat
    networkmanagerapplet
    nh
    nix-output-monitor
    onefetch
    openrazer-daemon
    orca-slicer
    p7zip
    polychromatic
    razer-cli
    ripgrep
    scrcpy
    slurp
    superfile
    tigervnc
    tree
    ungoogled-chromium
    unzip
    weathr
    wget
    zip

    # Wine Packages
    winePackages.full
    winetricks
  ];

  boot.kernelModules = [
    "usbnet"
    "cdc_ether"
  ];

  # NixOS Version
  system.stateVersion = "26.11"; # Did you read the comment?
}
