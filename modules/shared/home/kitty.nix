{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;

    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = "14";
      cursor_trail = "3";
      cursor_shape = "block";
      repaint_delay = "8";
      input_delay = "0";
      confirm_os_window_close = "0";
      dynamic_background_opacity = true;
      url_style = "curly";
      sync_to_monitor = "no";

      scrollbar_handle_opacity = "0";
      scrollbar_track = "0";
      scrollbar_track_hover_opacity = "0";
    };
  };
}
