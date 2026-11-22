{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = { alienix.system.vault-dashboard.enable = mkEnableOption "Enable the OurVault dashboard"; };

  # A TV-friendly web view of OurVault (the vault shared with Ashley) for any
  # browser on the home network: http://alienix:8088 or http://<laptop IP>:8088.
  # Neon look from the Cybergirl palette. The vault stays the source: the script
  # re-reads it, so edits in Obsidian show up on the next page load.
  # Code: ~/Projects/vault-dashboard (the archived LifeVault version is in
  # ~/Projects/archive/lifevault-dashboard). Only answers home-network IPs.
  config = mkIf config.alienix.system.vault-dashboard.enable {
    systemd.services.vault-dashboard = {
      description = "OurVault dashboard";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      serviceConfig = {
        User = "dex";
        Group = "users";
        ExecStart = concatStringsSep " " [
          "${pkgs.python3}/bin/python3 /home/dex/Projects/vault-dashboard/dashboard.py"
          "--vault /home/dex/OurVault"
          "--port 8088"
          "--font-dir ${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono"
        ];
        Restart = "always";
        RestartSec = 5;

        # It only ever reads.
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    };

    networking.firewall.allowedTCPPorts = [8088];
  };
}
