{ config, ... }:
let
  colors = config.lib.stylix.colors;
in
{
  # Stylix ships its own hyprlock home-manager target (enabled by default
  # whenever stylix.enable = true) that injects programs.hyprlock.settings
  # for background/input-field. It writes the exact same leaf keys we set
  # below by hand, which would otherwise fail eval with "conflicting
  # definitions". Disable it fully so this hand-crafted config is the only
  # source of truth (same pattern as swaylock.nix disabling its image target).
  stylix.targets.hyprlock.enable = false;

  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = false;
        ignore_empty_input = true;
      };

      animations = {
        enabled = true;
        bezier = "easeOutQuint, 0.23, 1, 0.32, 1";
        animation = [
          "fadeIn, 1, 5, easeOutQuint"
          "fadeOut, 1, 5, easeOutQuint"
          "inputFieldDots, 1, 2, easeOutQuint"
        ];
      };

      # Blurred, darkened wallpaper behind everything.
      background = {
        path = toString ../../../../wallpapers/anime/cybergirl.jpg;
        color = "rgb(${colors.base00-hex})";
        blur_size = 6;
        blur_passes = 3;
        noise = 0.02;
        contrast = 1.05;
        brightness = 0.45;
        vibrancy = 0.2;
        vibrancy_darkness = 0.3;
      };

      # Glass "card" behind the input field, bottom-anchored so it sits at a
      # fixed margin from the screen edge on every monitor regardless of
      # height (valign=bottom uses a flat offset, not a viewport-relative
      # one) — vertically centered on the input field below.
      shape = {
        size = "440, 140";
        rounding = 26;
        color = "rgba(${colors.base00-hex}66)";
        border_size = 2;
        border_color = "rgba(${colors.base0D-hex}55) rgba(${colors.base0E-hex}55) 45deg";
        position = "0, 54";
        halign = "center";
        valign = "bottom";
        zindex = -1;
      };

      label = [
        # Big clock. Mono (non-Propo) JetBrainsMono is used here on purpose:
        # its digits are fixed-width, so as $TIME ticks over (e.g. "11:59"
        # -> "12:00") the glyphs don't shift horizontally like they would
        # with the proportional "Propo" cut — important at a huge point
        # size where any per-frame width jitter is very noticeable.
        # Note: hyprlock's Y offset grows *upward* from its baseline, so
        # "170" here means 170px above true center, not below.
        {
          text = "<b>$TIME</b>";
          font_family = "JetBrainsMono Nerd Font";
          font_size = 150;
          color = "rgb(${colors.base06-hex})";
          position = "0, 170";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
          shadow_size = 4;
          shadow_color = "rgba(${colors.base00-hex}cc)";
        }
        # Date. Smaller UI text uses the Propo (proportional) cut, matching
        # waybar/rofi/dunst elsewhere in this config, since kerning matters
        # more than fixed-width alignment at this size. Uppercased for a
        # sharper, more "designed" look under the big clock.
        {
          text = ''cmd[update:43200000] date +'%A, %d %B' | tr '[:lower:]' '[:upper:]' '';
          font_family = "JetBrainsMono Nerd Font Propo";
          font_size = 30;
          color = "rgb(${colors.base04-hex})";
          position = "0, 40";
          halign = "center";
          valign = "center";
        }
        # Personalized greeting, now sitting just above the password card
        # (bottom-anchored) instead of stacked with the clock/date above.
        {
          text = "<i>Welcome back, dex</i>";
          font_family = "JetBrainsMono Nerd Font Propo";
          font_size = 20;
          color = "rgb(${colors.base0C-hex})";
          position = "0, 210";
          halign = "center";
          valign = "bottom";
        }
      ];

      input-field = {
        size = "360, 68";
        rounding = 20;
        outline_thickness = 3;
        inner_color = "rgba(${colors.base01-hex}cc)";
        outer_color = "rgba(${colors.base0D-hex}ee) rgba(${colors.base0E-hex}ee) 45deg";
        check_color = "rgba(${colors.base0B-hex}ee) rgba(${colors.base0C-hex}ee) 120deg";
        fail_color = "rgba(${colors.base08-hex}ee) rgba(${colors.base0F-hex}ee) 40deg";
        capslock_color = "rgba(${colors.base0A-hex}ee)";
        font_color = "rgb(${colors.base06-hex})";
        font_family = "JetBrainsMono Nerd Font Propo";
        fade_on_empty = false;
        dots_spacing = 0.3;
        placeholder_text = "<i>Enter password...</i>";
        fail_text = "<i>$FAIL</i>";
        check_text = "Verifying...";
        position = "0, 90";
        halign = "center";
        valign = "bottom";
        shadow_passes = 2;
        shadow_size = 3;
        shadow_color = "rgba(${colors.base00-hex}cc)";
      };
    };
  };
}
