{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  # The three Obsidian vaults live on alienix; the e-Garage drive only holds backups.
  vaults = {
    LifeVault = "/home/dex/LifeVault"; # Matthew's own
    OurVault = "/home/dex/OurVault"; # shared with Ashley (Syncthing)
    AshleyVault = "/home/dex/AshleyVault"; # Ashley's own (Syncthing)
  };
  dest = "/mnt/e-Garage/Backups/Vaults";

  script = pkgs.writeShellScript "vault-backup" ''
    set -eu
    # e-Garage is an automount: only look at it when it's really there, so an
    # unplugged drive doesn't hang the job. (exFAT: no hard links or Unix
    # permissions, so it's a plain mirror plus one dated archive per day.)
    if ! ${pkgs.util-linux}/bin/findmnt -n -t exfat /mnt/e-Garage >/dev/null; then
      echo "e-Garage drive not plugged in; skipping"
      exit 0
    fi
    today=$(date +%F)
    ${concatStringsSep "\n" (
      mapAttrsToList (name: src: ''
        if [ -d "${src}" ]; then
          mkdir -p "${dest}/${name}/current"
          # Hourly mirror of the vault as it is now.
          ${pkgs.rsync}/bin/rsync -rt --delete --modify-window=2 \
            --exclude .stversions --exclude .stfolder --exclude '.syncthing.*' \
            "${src}/" "${dest}/${name}/current/"
          # One dated archive per day, kept 30 days.
          archive="${dest}/${name}/${name} $today.tar.gz"
          if [ ! -e "$archive" ]; then
            ${pkgs.gnutar}/bin/tar -czf "$archive.part" --exclude .stversions --exclude .stfolder \
              -C "$(dirname "${src}")" "$(basename "${src}")"
            mv "$archive.part" "$archive"
            echo "${name}: saved $archive"
          fi
          find "${dest}/${name}" -maxdepth 1 -name '${name} *.tar.gz' -mtime +30 -delete
        fi
      '') vaults
    )}
  '';
in
{
  options.alienix.system.vault-backup.enable =
    mkEnableOption "Back up the three vaults to the e-Garage drive";

  # Copies LifeVault, OurVault and AshleyVault to e-Garage/Backups/Vaults/<vault>/:
  #   current/                 an hourly mirror
  #   <vault> YYYY-MM-DD.tar.gz  one per day, last 30 days
  # Runs hourly and whenever the drive gets mounted; skips quietly when it's out.
  config = mkIf config.alienix.system.vault-backup.enable {
    systemd.services.vault-backup = {
      description = "Back up the Obsidian vaults to the e-Garage drive";
      after = [ "mnt-e\\x2dGarage.mount" ];
      wantedBy = [ "mnt-e\\x2dGarage.mount" ]; # also run right after the drive is plugged in
      serviceConfig = {
        Type = "oneshot";
        User = "dex";
        Group = "users";
        ExecStart = script;
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        ReadWritePaths = [ "-/mnt/e-Garage" ];
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    };

    systemd.timers.vault-backup = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "hourly";
        RandomizedDelaySec = "5min";
        Persistent = true;
      };
    };
  };
}
