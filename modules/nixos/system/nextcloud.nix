{ pkgs, ... }:
{
  services.nextcloud = {
    enable = false;
    hostName = "nextcloud.tld";
    database.createLocally = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = "/var/lib/nextcloud/admin-pass";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
