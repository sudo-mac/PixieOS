{
  config,
  lib,
  ...
}:
with lib;
let
  theme = config.alienix.theme.active;
  style = theme.style.rofi theme;
in
{
  config = mkIf (theme.components.launcher == "rofi") {
    programs.rofi = {
      enable = true;
      theme = mkForce theme.meta.name;
    };

    # `display-drun` is a glyph rather than the blank it used to be: it is what
    # fills rofi's `prompt` widget, and with " " in it the inputbar came up as an
    # empty rounded box with nothing to say what it was for. The theme colours
    # it and gives the entry beside it a placeholder; see style/rofi.nix.
    #
    # Note for anyone editing the block below: rasi comments are /* */ or //.
    # A `#` line is a parse error, and rofi answers one by refusing to open at
    # all -- it does not fall back to the default theme.
    xdg.configFile."rofi/${theme.meta.name}.rasi".text = ''
      configuration {
        show-icons: true;
        icon-theme: "${style.iconTheme}";
        display-drun: "󰍉";
        drun-display-format: "{icon}  {name}";
      }

      ${style.rasi}
    '';
  };
}
