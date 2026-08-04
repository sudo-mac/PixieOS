{
  programs.waybar = {
    settings.mainBar."hyprland/window" = {
      format = "{title}";
      max-length = 40;
      separate-outputs = true;
    };

    style = ''
      #window {
        color: alpha(@base05, 0.85);
        font-style: italic;
        padding: 0 12px;
      }
    '';
  };
}
