# Presentation for the bar. Returns the GTK-CSS plus the few colour-bearing
# settings fragments (cpu ramp, calendar spans) that waybar expresses as
# Pango markup inside its config rather than as CSS.
{ tokens, fonts, c, ... }:
let
  inherit (tokens) radius opacity;

  glow = c.glowCss tokens.glow.color;

  # The rounded, glowing "pill" every bar module sits in.
  pill = ''
    background: alpha(@base01, ${toString opacity.panel});
    border: 1px solid alpha(@${tokens.glow.color}, 0.24);

    box-shadow:
      ${glow};

    border-radius: ${toString radius.pill}px;
  '';
in
{
  css = ''
    * {
      border: none;

      font-size: 16px;
      font-family: ${fonts.ui.name};
      font-weight: 500;

      min-height: 0;
      margin: 0;
      padding: 0px;
    }

    window#waybar {
      background: linear-gradient(
        90deg,
        alpha(@base00, ${toString opacity.bar}),
        alpha(@base01, 0.75),
        alpha(@base00, ${toString opacity.bar})
      );

      border: 1px solid alpha(@${tokens.glow.color}, 0.18);
      border-width: 0px;
      border-radius: 0px;
      border-bottom: none;
      padding: 8px 20px;
      min-height: 64px;
      margin: 0;
    }

    #clock,
    #cpu,
    #tray,
    #pulseaudio,
    #custom-power,
    #battery,
    #network,
    #mpris {
      ${pill}
      color: @${c.slotOf "primary"};

      padding: 6px 12px;
      margin: 0 10px;
      min-height: 28px;
    }

    #clock {
      font-weight: 600;
    }

    #mpris {
      color: @${c.slotOf "ok"};
      margin-right: 0;
    }

    #custom-media-popup {
      background: transparent;
      border: none;
      box-shadow: none;
      color: alpha(@${c.slotOf "ok"}, 0.85);
      padding: 6px 8px 6px 2px;
      margin: 0 10px 0 0;
      min-height: 0;
    }

    #window {
      color: alpha(@base05, 0.85);
      font-style: italic;
      padding: 0 12px;
    }

    #workspaces {
      ${pill}
      padding: 2px;
    }

    #workspaces button {
      transition: all 300ms ease-in-out;

      margin: 0;
      border: none;
      background: transparent;
      border-radius: ${toString radius.pill}px;
      color: @${c.slotOf "primary"};
      padding: 4px 10px;

      box-shadow: none;
    }

    #workspaces button.active {
      color: @base00;

      border: none;
      border-radius: ${toString radius.pill}px;

      background: linear-gradient(
        135deg,
        @${c.slotOf "primary"},
        @${c.slotOf "secondary"}
      );

      box-shadow:
        ${c.glowCss (c.slotOf "primary")},
        0 0 14px alpha(@${c.slotOf "primary"}, 0.18);

      min-width: 50px;
    }
  '';

  # Load ramp, quiet -> busy.
  cpuFormatIcons =
    map (pair: "<span color='${c.hex (builtins.head pair)}'>${builtins.elemAt pair 1}</span>") [
      [ (c.slotOf "ok") "▁" ]
      [ (c.slotOf "ok") "▂" ]
      [ "base0D" "▃" ]
      [ "base0D" "▄" ]
      [ (c.slotOf "warn") "▅" ]
      [ (c.slotOf "warn") "▆" ]
      [ "base09" "▇" ]
      [ (c.slotOf "primary") "█" ]
    ];

  calendarFormat = {
    months = "<span color='${c.hex "base0D"}'><b>{}</b></span>";
    days = "<span color='${c.hex "base05"}'><b>{}</b></span>";
    weeks = "<span color='${c.accentHex "ok"}'><b>W{}</b></span>";
    weekdays = "<span color='${c.accentHex "warn"}'><b>{}</b></span>";
    today = "<span color='${c.accentHex "primary"}'><b><u>{}</u></b></span>";
  };
}
