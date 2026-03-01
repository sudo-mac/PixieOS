{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./rofi.nix
    ./monitors.nix
    ./keybindings.nix
    ./appearance.nix
    ./waybar
  ];

  options = {
    alienix.home.hyprland.enable = mkEnableOption "Enable Hyprland Home-Manager settings";
  };

  config = mkIf config.alienix.home.hyprland.enable {
    # Hyprland Configuration
    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        exec-once = ["bash /etc/nixos/modules/home/desktop/hyprland/start.sh"];
      };
    };

    # Install extras for better Hyprland user experience
    home.packages = with pkgs; [
      waybar
      dunst
      wlogout
      swww
      networkmanagerapplet
      libnotify
    ];
  };
}
