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
  ];

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        blur = true;

        modules-left = ["hyprland/workspaces"];

        modules-center = ["clock"];

        modules-right = ["cpu" "network" "pulseaudio" "battery" "custom/power"];

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
       border-radius: 8px;
       border-bottom: none;
       padding: 8px 20px;
       min-height: 64px;
       margin: 4px 0;
      }

      #clock,
      #cpu,
      #tray,
      #pulseaudio,
      #custom-power,
      #battery,
      #network {
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
    '';
  };
  stylix.targets.waybar.enable = true;
}
