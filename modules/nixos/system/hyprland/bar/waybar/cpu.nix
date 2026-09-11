{ config, ... }:
let
  theme = config.alienix.theme.active;
in
{
  programs.waybar.settings.mainBar.cpu = {
    interval = 5;

    # A glyph and a number, not sixteen block glyphs. The per-core ramp is a
    # good inspection view and a bad permanent one: at rest all sixteen cores
    # draw the same 1/8 block sitting on the text baseline, so an idle machine
    # renders a dashed rule along the bottom of the island that reads as a
    # rendering artifact rather than as a meter. Dimming the two idle steps was
    # an earlier attempt at the same problem and did not fix it, because the
    # shape is what is wrong, not the contrast.
    format = "󰍛 {usage}%";

    # The ramp survives as the click-through. `format-alt-click` has to be set:
    # waybar toggles format-alt on button 1 by default *in addition to* running
    # on-click, so leaving it at the default would make one left-click both
    # launch btop and flip the module to the ramp behind it.
    format-alt = "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}{icon8}{icon9}{icon10}{icon11}{icon12}{icon13}{icon14}{icon15}";
    format-alt-click = 3;
    format-icons = (theme.style.waybar theme).cpuFormatIcons;

    # Drives #cpu.warning / #cpu.critical in the stylesheet, so a busy machine
    # is legible from the colour without reading the number. States fire at or
    # above their value for every module except battery.
    states = {
      warning = 70;
      critical = 90;
    };

    on-click = "kitty btop";
  };
}
