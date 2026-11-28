{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  # Blockboard: Matthew's own Notion/Habitica-style app (~/Projects/Blockboard).
  # Blocks instead of pages; its own SQLite data in ~/Projects/Blockboard/data/.
  # It reads LifeVault + OurVault (never writes them) when you press
  # "Refresh from vault". It only answers home-network IPs.
  dir = "/home/dex/Projects/Blockboard";
  port = 8094;
in {
  options.alienix.system.blockboard.enable = mkEnableOption "Enable Blockboard (Matthew's Blocks app, port 8094)";

  # http://alienix:8094  (also installable on a phone: "Add to Home screen")
  config = mkIf config.alienix.system.blockboard.enable {
    systemd.services.blockboard = {
      description = "Blockboard";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      environment.PYTHONDONTWRITEBYTECODE = "1";
      serviceConfig = {
        User = "dex";
        Group = "users";
        WorkingDirectory = dir;
        ExecStart = "${pkgs.python3}/bin/python3 ${dir}/run.py --port ${toString port}";
        Restart = "always";
        RestartSec = 5;

        # Read-only everywhere (the vaults included), except its own data folder.
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        ReadWritePaths = ["${dir}/data"];
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    };
    networking.firewall.allowedTCPPorts = [port];
  };
}
