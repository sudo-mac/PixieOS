# Presentation for the Claude Code statusline and settings.
{ meta, c, ... }:
{
  settingsTheme = if meta.polarity == "light" then "light" else "dark";

  # Substituted into claude-statusline.sh, replacing the nine hand-copied
  # BASE0X hex vars it used to declare inline.
  colors = {
    base01 = c.bare "base01";
    base02 = c.bare "base02";
    base04 = c.bare "base04";
    base05 = c.bare "base05";
    accent = c.accentBare "primary";
    warn = c.accentBare "warn";
    ok = c.accentBare "ok";
    info = c.accentBare "info";
    edge = c.bare "base0D";
  };
}
