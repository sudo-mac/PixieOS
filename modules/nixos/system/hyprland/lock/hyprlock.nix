{
  config,
  lib,
  ...
}:
with lib;
let
  theme = config.alienix.theme.active;
  style = theme.style.hyprlock theme;
in
{
  config = mkIf (theme.components.lock == "hyprlock") {
    # Stylix ships its own hyprlock target (enabled by default whenever
    # stylix.enable = true) that injects programs.hyprlock.settings for
    # background/input-field. It writes the exact same leaf keys the theme does,
    # which would otherwise fail eval with "conflicting definitions". Disable it
    # fully so the theme is the only source of truth.
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
        background = style.background;

        # Glass "card" behind the input field, bottom-anchored so it sits at a
        # fixed margin from the screen edge on every monitor regardless of
        # height (valign=bottom uses a flat offset, not a viewport-relative
        # one) -- vertically centered on the input field below.
        shape = {
          size = "440, 140";
          position = "0, 54";
          halign = "center";
          valign = "bottom";
          zindex = -1;
        }
        // style.shape;

        label = [
          # Big clock. Mono (non-Propo) JetBrainsMono is used here on purpose:
          # its digits are fixed-width, so as $TIME ticks over (e.g. "11:59"
          # -> "12:00") the glyphs don't shift horizontally like they would
          # with the proportional "Propo" cut -- important at a huge point
          # size where any per-frame width jitter is very noticeable.
          # Note: hyprlock's Y offset grows *upward* from its baseline, so
          # "170" here means 170px above true center, not below.
          ({
            text = "<b>$TIME</b>";
            font_size = 150;
            position = "0, 170";
            halign = "center";
            valign = "center";
            shadow_passes = 2;
            shadow_size = 4;
          }
          // style.clock)

          # Date. Smaller UI text uses the Propo (proportional) cut, matching
          # waybar/rofi/dunst elsewhere in this config, since kerning matters
          # more than fixed-width alignment at this size. Uppercased for a
          # sharper, more "designed" look under the big clock.
          ({
            text = ''cmd[update:43200000] date +'%A, %d %B' | tr '[:lower:]' '[:upper:]' '';
            font_size = 30;
            position = "0, 40";
            halign = "center";
            valign = "center";
          }
          // style.date)

          # Personalized greeting, sitting just above the password card
          # (bottom-anchored) rather than stacked with the clock/date above.
          ({
            text = "<i>Welcome back, dex</i>";
            font_size = 20;
            position = "0, 210";
            halign = "center";
            valign = "bottom";
          }
          // style.greeting)
        ];

        input-field = {
          size = "360, 68";
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
        }
        // style.input;
      };
    };
  };
}
