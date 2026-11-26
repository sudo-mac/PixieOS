{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.alienix.system.ebay-sync.enable = mkEnableOption "Hourly eBay pull into LifeVault and OurVault";

  # Pulls SpooferDex's eBay numbers (orders, balance, payouts, listings, views)
  # with eBay's read-only seller APIs and rewrites one note in each vault:
  #   LifeVault: ~/LifeVault/01 - SpooferDex/eBay Live.md (phone costs need the e-Garage drive)
  #   OurVault:  ~/OurVault/01 - Home/SpooferDex eBay.md
  # Code: ~/Projects/ebay-sync. Secrets: ~/.config/ebay-sync (one-time `ebay_sync.py --login`).
  config = mkIf config.alienix.system.ebay-sync.enable {
    systemd.services.ebay-sync = {
      description = "Pull eBay numbers into the vaults";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      environment.SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
      path = [pkgs.poppler-utils]; # pdftotext, for the wholesale invoice PDFs (phone costs)
      serviceConfig = {
        Type = "oneshot";
        User = "dex";
        Group = "users";
        ExecStart = "${pkgs.python3}/bin/python3 -I /home/dex/Projects/ebay-sync/ebay_sync.py";
        TimeoutStartSec = "5min";

        # Read-only everywhere, except the two vaults and its own token cache.
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        ReadWritePaths = [
          "/home/dex/OurVault"
          "/home/dex/LifeVault"
          "/home/dex/.config/ebay-sync"
        ];
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    };

    systemd.timers.ebay-sync = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "hourly";
        RandomizedDelaySec = "5min";
        Persistent = true; # catch up after the laptop was asleep or off
      };
    };
  };
}
