{pkgs, ...}: {
  # Allow Unfree Packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [
    tigervnc
    #   rustdesk
    appimage-run
    superfile
    kdePackages.dolphin
    anydesk
    bat
    gimp # Photo Editor
    #   ungoogled-chromium # Web Browser
    telegram-desktop # Private Messenger
    btop # System Monitor
    payload-dumper-go # Payload.bin dumper
    qt6.qttools # Add-ons for GNOME   zip
    brightnessctl
    zip
    unzip
    curl
    grim
    slurp
    fastfetch
    freecad # -- currently broken on most recent version. -- 01/01/2025
    git
    git-lfs
    gparted
    gzip
    p7zip
    exfatprogs
    libimobiledevice
    lolcat
    networkmanagerapplet
    openrazer-daemon
    polychromatic
    razer-cli
    scrcpy
    wget

    # Wine Packages
    winePackages.full
    winetricks
  ];

  # Inside configuration.nix or your flake's module
  services.udev.extraRules = ''
    # Flipper Zero DFU Mode
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="df11", MODE="0666", GROUP="dialout"

    # Flipper Zero Serial Mode
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="5740", MODE="0666", GROUP="dialout"
  '';
}
