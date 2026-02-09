{ config, lib, pkgs, ... }:
with lib; {
  options = { alienix.system.gaming.minecraft.enable = mkEnableOption "Enable Minecraft Launcher, Server Capabilities, and other Minecraft related packages."; };

  config = mkIf config.alienix.system.gaming.minecraft.enable {
    environment.systemPackages = with pkgs; [
      prismlauncher # Open Source Mincraft Launcher
      craftos-pc # ComputerCraft Terminal Emulator
      worldpainter # World Painter World Editor
    ];
  };
}
