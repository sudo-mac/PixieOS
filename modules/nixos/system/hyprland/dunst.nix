{ config, ... }:
let
  colors = config.lib.stylix.colors;
in
{
  stylix.targets.dunst.enable = false;

  services.dunst = {
    enable = true;

    settings = {
      global = {
        monitor = 0;
        follow = "mouse";

        width = "(280,400)";
        height = 300;
        origin = "top-right";
        offset = "16x50";
        scale = 0;
        notification_limit = 5;

        progress_bar = true;
        progress_bar_height = 12;
        progress_bar_frame_width = 0;
        progress_bar_min_width = 200;
        progress_bar_max_width = 300;
        highlight = "#${colors.base0D}";

        corner_radius = 18;
        frame_width = 2;
        frame_color = "#${colors.base0D}";
        separator_color = "frame";
        separator_height = 2;

        padding = 14;
        horizontal_padding = 14;
        text_icon_padding = 10;

        font = "JetBrainsMono Nerd Font Propo 11";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        ellipsize = "middle";
        ignore_newline = false;
        show_age_threshold = 60;

        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;

        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 64;

        sticky_history = true;
        history_length = 20;

        transparency = 8;
        idle_threshold = 120;

        mouse_left_click = "close_current";
        mouse_middle_click = "do_action";
        mouse_right_click = "close_all";
      };

      urgency_low = {
        background = "#${colors.base00}";
        foreground = "#${colors.base04}";
        frame_color = "#${colors.base02}";
        timeout = 5;
      };

      urgency_normal = {
        background = "#${colors.base00}";
        foreground = "#${colors.base05}";
        frame_color = "#${colors.base0D}";
        timeout = 8;
      };

      urgency_critical = {
        background = "#${colors.base00}";
        foreground = "#${colors.base07}";
        frame_color = "#${colors.base08}";
        timeout = 0;
      };
    };
  };
}
