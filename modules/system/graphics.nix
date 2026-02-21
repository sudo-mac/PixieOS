{ inputs, pkgs, lib, ... }: {

  # System Configuration
  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;
    enableRedistributableFirmware = true;
  };

  # Enable Modern Drivers
  services.xserver.videoDrivers = [ "radeon" "amdgpu" ];
}
