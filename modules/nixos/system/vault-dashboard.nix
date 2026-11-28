{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  fontDir = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono";

  # One web server per vault, all from one codebase (~/Projects/vault-dashboards,
  # `run.py --site <name>`). Each page re-reads the vault, so edits in Obsidian
  # show up straight away, and it restarts itself when its code changes. It only
  # answers home-network IPs. Each one can edit its own vault (tick, add, full
  # note editing, new/rename/move/archive/trash) and nothing else.
  code = "/home/dex/Projects/vault-dashboards/run.py";
  mkDashboard =
    {
      description,
      site,
      vault,
      port,
    }:
    {
      inherit description;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment.PYTHONDONTWRITEBYTECODE = "1";
      serviceConfig = {
        User = "dex";
        Group = "users";
        ExecStart = "${pkgs.python3}/bin/python3 ${code} --site ${site} --vault ${vault} --port ${toString port} --font-dir ${fontDir}";
        Restart = "always";
        RestartSec = 5;

        # Read-only everywhere, except its own vault.
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        ReadWritePaths = [ vault ];
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    };
in
{
  options = {
    alienix.system.vault-dashboard.enable = mkEnableOption "Enable Mashley's Dashboard (OurVault, port 8088)";
    alienix.system.lifevault-dashboard.enable = mkEnableOption "Enable the LifeVault dashboard (port 8090)";
    alienix.system.ashley-dashboard.enable = mkEnableOption "Enable Ashley's dashboard (AshleyVault, port 8092)";
  };

  # Web views of the three vaults, for any browser on the home network:
  #   Mashley's Dashboard: OurVault, shared with Ashley. Neon (Cybergirl), made for the TV.
  #     http://alienix:8088
  #   LifeVault: Matthew's own vault (~/LifeVault). Kimberly theme, tablet first.
  #     http://alienix:8090
  #   Ashley's Dashboard: Ashley's own vault (~/AshleyVault). Soft light/dark look. No lock.
  #     http://alienix:8092
  config = mkMerge [
    (mkIf config.alienix.system.vault-dashboard.enable {
      systemd.services.vault-dashboard = mkDashboard {
        description = "Mashley's Dashboard (OurVault)";
        site = "mashley";
        vault = "/home/dex/OurVault";
        port = 8088;
      };
      networking.firewall.allowedTCPPorts = [ 8088 ];
    })

    (mkIf config.alienix.system.lifevault-dashboard.enable {
      systemd.services.lifevault-dashboard = mkDashboard {
        description = "LifeVault dashboard";
        site = "lifevault";
        vault = "/home/dex/LifeVault";
        port = 8090;
      };
      networking.firewall.allowedTCPPorts = [ 8090 ];
    })

    (mkIf config.alienix.system.ashley-dashboard.enable {
      systemd.services.ashley-dashboard = mkDashboard {
        description = "Ashley's dashboard (AshleyVault)";
        site = "ashley";
        vault = "/home/dex/AshleyVault";
        port = 8092;
      };
      networking.firewall.allowedTCPPorts = [ 8092 ];
    })
  ];
}
