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

  # plymouth needs to start in the initrd to cover the whole boot.
  boot.initrd.systemd.enable = true;

  # `quiet` on its own is not quiet. It lowers the console log level to 4, which
  # still prints everything at KERN_ERR and above -- and on this machine that is
  # a page of ACPI BIOS errors (the firmware's own DSDT referring to symbols it
  # never defines: \_SB.PCI0.GPP2.WWAN, .GPP5.RTL8, .GPP7.DEV0, \_TZ.THRM._SCP)
  # plus two NVRM assertions about SBIOS not answering a temperature query.
  # Every one of them is the laptop's firmware being wrong about hardware that
  # isn't fitted, none of them is actionable, and they were what landed on top
  # of the splash.
  #
  # 3 rather than 0, because `loglevel=N` prints everything *below* N: crit,
  # alert and emerg -- the three classes that mean the boot is actually going
  # wrong -- still reach the screen. Nothing is being discarded either way; the
  # full log is still in the journal (`journalctl -b -p 3 -k`).
  boot.consoleLogLevel = 3;

  # The other two writers on that screen are systemd's per-unit status lines and
  # udev's own logging, each of which has to be silenced twice: once for the
  # initrd (the rd.* pair) and once for stage 2.
  #
  # boot.initrd.verbose would be the option-shaped way to say the first half,
  # but it is only read by the shell-script stage 1 -- nothing in nixpkgs looks
  # at it once boot.initrd.systemd.enable is on -- so the parameters are spelled
  # out here instead.
  boot.kernelParams = [
    # `splash` is not listed: boot.plymouth.enable adds it, and naming it here
    # too is how it ended up on the command line twice.
    "quiet"

    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"

    "systemd.show_status=false"
    "udev.log_level=3"
  ];
}
