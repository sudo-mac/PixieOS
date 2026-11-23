{
  alienix.theme.name = "kimberly";

  alienix.system = {
    asus.enable = true;
    graphics.nvidia.enable = true;
    hyprland.enable = true;

    # The login screen lives on the laptop panel, whatever else is plugged in.
    # Same output monitors.lua puts at 0x0.
    greeter.output = "eDP-1";

    ssh.enable = true;
    virtualisation.enable = true;
    libreoffice.enable = true;
    nextcloud.enable = false;
    syncthing.enable = true; # OurVault, shared with Ashley
    vault-dashboard.enable = true; # Mashley's Dashboard (OurVault): http://alienix:8088
    lifevault-dashboard.enable = true; # LifeVault dashboard: http://alienix:8090
    ebay-sync.enable = true; # hourly eBay numbers into LifeVault + OurVault (~/Projects/ebay-sync)
    ssd.enable = true;

    gaming = {
      enable = true;

      minecraft = {
        enable = true;
        servers.fabric-1_21_1.enable = false;
      };
    };
  };
}
