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
    syncthing.enable = true; # OurVault (shared) + AshleyVault (hers), synced with Ashley's PC
    vault-dashboard.enable = true; # Mashley's Dashboard (OurVault): http://alienix:8088
    lifevault-dashboard.enable = true; # LifeVault dashboard: http://alienix:8090
    ashley-dashboard.enable = true; # Ashley's dashboard (AshleyVault): http://alienix:8092
    vault-backup.enable = true; # hourly copy of the 3 vaults to e-Garage/Backups/Vaults
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
