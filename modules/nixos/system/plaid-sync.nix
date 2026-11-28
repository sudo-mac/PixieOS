{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.alienix.system.plaid-sync.enable =
    mkEnableOption "Daily Plaid pull of bank and card transactions";

  # Pulls bank and card transactions through Plaid's free Trial plan (read-only)
  # into a vault note and, while the external drive is plugged in, one CSV per
  # account per year on it.
  # Code: ~/Projects/plaid-sync. Secrets: ~/.config/plaid-sync (`plaid-login`).
  config = mkIf config.alienix.system.plaid-sync.enable {
    systemd.services.plaid-sync = {
      description = "Pull bank and card transactions from Plaid";
      after = [
        "network-online.target"
        "mnt-e\\x2dGarage.mount"
      ];
      wants = [ "network-online.target" ];
      wantedBy = [ "mnt-e\\x2dGarage.mount" ]; # also run right after the drive is plugged in
      environment.SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
      serviceConfig = {
        Type = "oneshot";
        User = "dex";
        Group = "users";
        ExecStart = "${pkgs.python3}/bin/python3 -I /home/dex/Projects/plaid-sync/plaid_sync.py";
        TimeoutStartSec = "10min";

        # Read-only everywhere, except LifeVault, its own data and the drive (if it's in).
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        ReadWritePaths = [
          "/home/dex/LifeVault"
          "-/home/dex/.config/plaid-sync"
          "-/mnt/e-Garage"
        ];
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    };

    systemd.timers.plaid-sync = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 07:00";
        RandomizedDelaySec = "15min";
        Persistent = true; # catch up after the laptop was asleep or off
      };
    };
  };
}
