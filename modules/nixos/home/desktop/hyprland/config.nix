{
  config,
  pkgs,
  lib,
  ...
}:
with lib;

{

  options = {
    alienix.home.hyprland.enable = mkEnableOption "Enable Hyprland Home-Manager settings";
  };

  config = mkIf config.alienix.home.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;

      extraLuaFiles.example-lua.autoLoad = true;
    };

    # Install extras for better Hyprland user experience
    home.packages = with pkgs; [
      waybar
      dunst
      wlogout
      swaylock
      awww
      networkmanagerapplet
      libnotify
    ];
  };
}
