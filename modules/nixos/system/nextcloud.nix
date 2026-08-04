{
  config,
  lib,
  ...
}:
with lib; {
  options = { alienix.system.nextcloud.enable = mkEnableOption "Enable Nextcloud"; };

  config = mkIf config.alienix.system.nextcloud.enable {
    services.nextcloud = {
      enable = true;
      hostName = "74.132.82.148";
      database.createLocally = true;
      config = {
        dbtype = "pgsql";
        adminpassFile = "/var/lib/nextcloud/admin-pass";
      };
    };

    services.nginx.enable = true;

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
