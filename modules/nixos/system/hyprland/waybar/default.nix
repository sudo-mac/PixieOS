{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./cpu.nix
    ./tray.nix
    ./battery.nix
    ./clock.nix
    ./pulseaudio.nix
    ./workspaces.nix
    ./network.nix
    ./window.nix
    ./media.nix
  ];

  home.packages = [ pkgs.playerctl ];

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        blur = true;

        modules-left = ["hyprland/workspaces" "hyprland/window"];

        modules-center = ["clock" "mpris" "custom/media-popup"];

        modules-right = ["cpu" "network" "pulseaudio" "battery" "tray" "custom/power"];

        "custom/media-popup" = {
          format = "";
          tooltip = "Now playing — click to expand";
          on-click = ''rofi -show media-player -modi "media-player:$HOME/.config/rofi/scripts/media-player.sh"'';
        };

        "custom/power" = {
          format = "⏻";
          tooltip = "Power";
          on-click = "wlogout";
        };
      };
    };

    style = ''
      * {
        border: none;

        font-size: 16px;
        font-family: JetBrainsMono Nerd Font Propo;
        font-weight: 500;

        min-height: 0;
        margin: 0;
        padding: 0px;
      }

      window#waybar {
       background: linear-gradient(
            90deg,
            alpha(@base00, 0.85),
            alpha(@base01, 0.75),
            alpha(@base00, 0.85)
       );

       border: 1px solid alpha(@base0D, 0.18);
       border-width: 0px;
       border-radius: 0px;
       border-bottom: none;
       padding: 8px 20px;
       min-height: 64px;
       margin: 0;
      }

      #clock,
      #cpu,
      #tray,
      #pulseaudio,
      #custom-power,
      #battery,
      #network,
      #mpris {
        background: alpha(@base01, 0.95);
        border: 1px solid alpha(@base0D, 0.24);
        color: @base08;

        box-shadow:
          0 0 4px alpha(@base0D, 0.75),
          0 0 8px alpha(@base0D, 0.35);

        border-radius: 999px;

        padding: 6px 12px;
        margin: 0 10px;
        min-height: 28px;
      }

      #mpris {
        color: @base0B;
        margin-right: 0;
      }

      #custom-media-popup {
        background: transparent;
        border: none;
        box-shadow: none;
        color: alpha(@base0B, 0.85);
        padding: 6px 8px 6px 2px;
        margin: 0 10px 0 0;
        min-height: 0;
      }
    '';
  };
  stylix.targets.waybar.enable = true;
}
