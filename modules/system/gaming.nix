{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {alienix.system.gaming.enable = mkEnableOption "Enable Gaming Compatibility";};

  config = mkIf config.alienix.system.gaming.enable {
    # Enable Steam
    programs.steam = {
      enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall =
        true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    # Enable Gaming Related Packages
    environment.systemPackages = with pkgs; [
      zulu25
      xivlauncher # Custom launcher for Final Fantasy XIV
      pokemmo-installer
      runescape
      runelite
      lutris # Open-source game manager for Linux
      heroic
      bottles
      #     rpcs3
      vulkan-tools # Vulkan utilities like vulkaninfo
      vulkan-loader # Vulkan loader
      vulkan-validation-layers
      mesa # Open-source AMD drivers
      minicom # [ To be listed... ]
      mangohud # System performance heads-up display for OpenGL and Vulkan applications
      protonup-ng
      gamescope
      vkd3d
      dxvk
      (wineWow64Packages.full.override {
        wineRelease = "staging";
        mingwSupport = true;
      })
      winetricks
    ];

    nixpkgs.config.permittedInsecurePackages = ["openssl-1.1.1w"];

    # Configure Steam path for ProtonGE
    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/user/.steam/root/compatibilitytools.d";
    };

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

    # Enable Game Mode for NixOS
    programs.gamemode.enable = true;

    # Enable Modern Drivers
    services.xserver.videoDrivers = ["radeon" "amdgpu" "nvidia"];
  };
}
