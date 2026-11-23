{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  fontDir = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono";

  # One web server per vault. The script re-reads the vault on every page load,
  # so edits in Obsidian show up straight away, and it restarts itself when its
  # own code changes. It only answers home-network IPs. `writable` lets it save
  # into that one vault (ticking boxes / adding items from the TV); otherwise
  # it can only read.
  mkDashboard = {
    description,
    code,
    vault,
    port,
    writable ? false,
  }: {
    inherit description;
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      User = "dex";
      Group = "users";
      ExecStart = "${pkgs.python3}/bin/python3 ${code} --vault ${vault} --port ${toString port} --font-dir ${fontDir}";
      Restart = "always";
      RestartSec = 5;

      # Read-only everywhere, except its own vault when writable.
      ProtectSystem = "strict";
      ProtectHome = "read-only";
      ReadWritePaths = optional writable vault;
      PrivateTmp = true;
      NoNewPrivileges = true;
    };
  };
in {
  options = {
    alienix.system.vault-dashboard.enable = mkEnableOption "Enable Mashley's Dashboard (OurVault, port 8088)";
    alienix.system.lifevault-dashboard.enable = mkEnableOption "Enable the LifeVault dashboard (port 8090)";
  };

  # TV-friendly web views of the vaults, for any browser on the home network:
  #   Mashley's Dashboard: OurVault, shared with Ashley. Neon (Cybergirl palette).
  #     http://alienix:8088  -- code: ~/Projects/vault-dashboard
  #   LifeVault: Matthew's own vault (needs the e-Garage drive). Kimberly theme.
  #     http://alienix:8090  -- code: ~/Projects/lifevault-dashboard
  config = mkMerge [
    (mkIf config.alienix.system.vault-dashboard.enable {
      systemd.services.vault-dashboard = mkDashboard {
        description = "Mashley's Dashboard (OurVault)";
        code = "/home/dex/Projects/vault-dashboard/dashboard.py";
        vault = "/home/dex/OurVault";
        port = 8088;
        writable = true; # tick / add from the TV
      };
      networking.firewall.allowedTCPPorts = [8088];
    })

    (mkIf config.alienix.system.lifevault-dashboard.enable {
      systemd.services.lifevault-dashboard = mkDashboard {
        description = "LifeVault dashboard";
        code = "/home/dex/Projects/lifevault-dashboard/dashboard.py";
        vault = "/mnt/e-Garage/LifeVault";
        port = 8090;
      };
      networking.firewall.allowedTCPPorts = [8090];
    })
  ];
}
