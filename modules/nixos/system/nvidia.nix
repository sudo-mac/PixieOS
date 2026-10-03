{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
with lib; {
  options = {alienix.system.graphics.nvidia.enable = mkEnableOption "Enable Nvidia Graphics Compatibility";};

  config = mkIf config.alienix.system.graphics.nvidia.enable {
    # System Configuration
    hardware = {
      graphics.enable = true;
      graphics.enable32Bit = true;
      enableRedistributableFirmware = true;
      nvidia = {
        # Off, because on this laptop it does not work and a power arbiter that
        # does not work is worse than none.
        #
        # Dynamic Boost is the driver negotiating with the firmware over how to
        # split a shared CPU+GPU power budget. Its daemon, nvidia-powerd, runs
        # and fails every request it makes, a couple of times a second:
        #
        #   nvidia-powerd: ERROR! JPAC is not created/already destroyed,
        #                  ignoring request.
        #
        # and the driver says why at boot, from the same code path:
        #
        #   NVRM: ... PlatformRequestHandler failed to get target temp from SBIOS
        #   NVRM: ... failed to get platform power mode from SBIOS
        #
        # The SBIOS on this machine does not answer the handler, so there is no
        # budget to negotiate. Switching it off drops the daemon and the log
        # spam and leaves the card on its static 60W TGP, which is what it was
        # effectively getting anyway.
        dynamicBoost.enable = false;

        modesetting.enable = true;
        powerManagement = {
          enable = false;
          finegrained = false;
        };
        open = true;
        nvidiaSettings = true;
      };
    };

    # This is the only display device in the machine -- the Ryzen 7 7435HS has
    # no integrated graphics, and lspci shows exactly one [0300] device -- so
    # the dGPU is driving the panel at all times and has nothing to hand off to.
    # supergfxd had set it to "auto" (see asus.nix, where supergfxd is now off);
    # runtime-suspending the GPU that owns the framebuffer is never what we want.
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", ATTR{power/control}="on"
    '';

    # Enable Nvidia Drivers. This is the one place the list is stated -- see
    # graphics.nix and gaming.nix, both of which used to add "radeon" and
    # "amdgpu" to it on a machine that has neither.
    services.xserver.videoDrivers = ["nvidia"];
  };
}
