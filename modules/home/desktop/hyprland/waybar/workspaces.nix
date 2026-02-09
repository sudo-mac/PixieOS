{
  programs.waybar = {
    settings.mainBar."hyprland/workspaces" = {
      format = "{name}";

      persistent-workspaces."*" = 1;
    };

    style = ''
      #workspaces {
          background: alpha(@base01, 0.95);
          border: 1px solid alpha(@base0D, 0.24);

          box-shadow:
            0 0 4px alpha(@base0D, 0.75),
            0 0 8px alpha(@base0D, 0.35);

          border-radius: 999px;
          padding: 2px;
      }

      #workspaces button {
        transition: all 300ms ease-in-out;

        margin: 0;
        border: none;
        background: transparent;
        border-radius: 999px;
        color: @base08;
        padding: 4px 10px;

        box-shadow: none;
      }

      #workspaces button.active {
        color: @base00;

        border: none;
        border-radius: 999px;

        background: linear-gradient(135deg, @base08, @base0F);

        box-shadow:
            0 0 4px alpha(@base08, 0.75),
            0 0 8px alpha(@base08, 0.35),
            0 0 14px alpha(@base08, 0.18);

        min-width: 50px;
      }
    '';
  };
}
