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

    # Configure Steam path for ProtonGE.
    #
    # This said /home/user, which is nobody: the directory it named has never
    # existed. GE-Proton is found anyway because Steam scans
    # ~/.steam/root/compatibilitytools.d by itself, so the variable was doing
    # nothing rather than breaking anything -- but it should point somewhere.
    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/dex/.steam/root/compatibilitytools.d";
    };

    # GameMode was enabled but unconfigured, which meant it was also unused: it
    # only does anything to a game that is launched through `gamemoderun`, and
    # with no [gpu] section it would not have touched the GPU even then.
    #
    # The two settings that matter here are desiredgov and nv_powermizer_mode.
    # The CPU sits on the powersave governor (amd-pstate-epp) the rest of the
    # time, which is right for a laptop; this borrows `performance` for the
    # length of a game and hands it back. nv_powermizer_mode = 1 is NVIDIA's
    # "Prefer Maximum Performance", the direct answer to the card idling at
    # 550MHz of its 2100MHz ceiling while a game holds the context.
    #
    # apply_gpu_optimisations has to be the literal string "accept-responsibility"
    # -- upstream will not touch the GPU without it, by design.
    programs.gamemode = {
      enable = true;

      settings = {
        general = {
          renice = 10;
          desiredgov = "performance";
          softrealtime = "auto";
          inhibit_screensaver = 1;
        };

        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          nv_powermizer_mode = 1;
        };
      };
    };

    # So there is something to measure with. MangoHud reads this when
    # MANGOHUD=1 is in the environment or the game is launched through
    # `mangohud`; frame_timing is the row that tells stutter apart from a low
    # average, which the fps counter on its own cannot.
    environment.etc."MangoHud/MangoHud.conf".text = ''
      fps
      frametime
      frame_timing=1
      gpu_stats
      gpu_temp
      gpu_core_clock
      gpu_power
      cpu_stats
      cpu_temp
      vram
      ram
      position=top-left
      font_size=20
      toggle_hud=Shift_R+F12
    '';

    # videoDrivers used to be set here as well, to [ "radeon" "amdgpu" "nvidia" ].
    # See nvidia.nix, which is the one place it is stated now.
  };
}
