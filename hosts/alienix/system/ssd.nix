{
  config,
  lib,
  ...
}:
with lib; {
  options = {alienix.system.ssd.enable = mkEnableOption "Enable e-Garage SSD auto-mount";};

  config = mkIf config.alienix.system.ssd.enable {
    fileSystems."/mnt/e-Garage" = {
      device = "/dev/disk/by-label/e-Garage";
      fsType = "exfat";
      options = [
        "uid=1000"
        "gid=100"
        "nofail"
        "auto"
        "x-systemd.automount"
        "x-systemd.device-timeout=5s"
      ];
    };
  };
}
