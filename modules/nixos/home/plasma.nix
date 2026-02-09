{ config, lib, pkgs, ... }:
with lib; {
  options = {
    plasmahome.enable =
      mkEnableOption "Enable and configure Plasma6 Home-Manager config";
  };

  config = mkIf config.plasmahome.enable {
    # Configure Plasma Theme
    programs.plasma = {
      enable = true;
      workspace = {
        colorScheme = "BreezeDark"; # Enables dark mode

        windowDecorations = {
          library = "org.kde.breeze";
          theme = "Breeze";
        };

        splashScreen = { theme = "None"; };

        theme = "BreezeDark";

        cursor = { theme = "Breeze"; };
      };
    };
  };
}
