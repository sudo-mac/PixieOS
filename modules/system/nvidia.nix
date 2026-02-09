{ config, inputs, pkgs, lib, ... }: with lib; {

  options = { alienix.system.graphics.nvidia.enable = mkEnableOption "Enable Nvidia Graphics Compatibility"; };

  config = mkIf config.alienix.system.graphics.nvidia.enable {
    # System Configuration
    hardware = {
      graphics.enable = true;
      graphics.enable32Bit = true;
      enableRedistributableFirmware = true;
      nvidia = {
        dynamicBoost.enable = true;
        modesetting.enable = true;
        powerManagement = {
          enable = false;
          finegrained = false;
        };
        open = true;
        nvidiaSettings = true;
      };
    };

    # Enable Nvidia Drivers
    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
