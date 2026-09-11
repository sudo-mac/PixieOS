{ config, lib, pkgs, ... }: {
  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiSupport = true;
    useOSProber = true;
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  # Without this the boot went themed GRUB -> a page of raw kernel text -> a
  # bare TTY. stylix's plymouth target auto-enables on Linux and themes the
  # splash from the active palette and wallpaper, so turning plymouth on is all
  # that is needed to close the gap.
  boot.plymouth.enable = true;

  # plymouth needs to start in the initrd to cover the whole boot, and `quiet`
  # is what keeps the kernel log from being drawn over the top of it.
  boot.initrd.systemd.enable = true;
  boot.kernelParams = [
    "quiet"
    "splash"
  ];
}
