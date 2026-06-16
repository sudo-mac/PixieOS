{
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

  fileSystems."/mnt/e-Garage" = {
    device = "/dev/disk/by-uuid/68E9-5E19";
    fsType = "exfat";
    options = [
      "uid=1000"
      "gid=100"
      "nofail"
      "auto"
    ];
  };
}
