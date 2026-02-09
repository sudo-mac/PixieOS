{config, ...}: let
  colors = config.lib.stylix.colors;
in {
  programs.waybar = {
    settings.mainBar.cpu = {
      on-click = "kitty btop";
      format = "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}{icon8}{icon9}{icon10}{icon11}{icon12}{icon13}{icon14}{icon15}";
      format-icons = [
        "<span color='#${colors.base0B}'>▁</span>"
        "<span color='#${colors.base0B}'>▂</span>"
        "<span color='#${colors.base0D}'>▃</span>"
        "<span color='#${colors.base0D}'>▄</span>"
        "<span color='#${colors.base0A}'>▅</span>"
        "<span color='#${colors.base0A}'>▆</span>"
        "<span color='#${colors.base09}'>▇</span>"
        "<span color='#${colors.base08}'>█</span>"
      ];
    };
  };
}
