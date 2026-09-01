{
  config,
  lib,
  ...
}:
with lib;
let
  theme = config.alienix.theme.active;
  style = theme.style.dunst theme;
in
{
  config = mkIf (theme.components.notifier == "dunst") {
    # Hand the whole thing to the theme; stylix would otherwise write competing
    # colour keys into the same settings.
    stylix.targets.dunst.enable = false;

    services.dunst = {
      enable = true;

      settings = {
        # Geometry and behaviour are functional and stay here.
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

          padding = 14;
          horizontal_padding = 14;
          text_icon_padding = 10;

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

          idle_threshold = 120;

          mouse_left_click = "close_current";
          mouse_middle_click = "do_action";
          mouse_right_click = "close_all";
        }
        // style.global;

        urgency_low = { timeout = 5; } // style.urgency_low;
        urgency_normal = { timeout = 8; } // style.urgency_normal;
        urgency_critical = { timeout = 0; } // style.urgency_critical;
      };
    };
  };
}
