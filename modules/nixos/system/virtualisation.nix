{ config
, lib
, pkgs
, ...
}:
with lib; {
  options = {
    alienix.system.virtualisation.enable =
      mkEnableOption "Enable Virtualisation module for virtual machines";
  };

  config = mkIf config.alienix.system.virtualisation.enable {
    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = [ "dex" ];
    virtualisation.waydroid.enable = true;
    virtualisation.libvirtd.enable = true;
    virtualisation.libvirtd.qemu.swtpm.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
