# Presentation for the bar. Returns the GTK-CSS plus the few colour-bearing
# settings fragments (cpu ramp, calendar spans) that waybar expresses as
# Pango markup inside its config rather than as CSS.
{ tokens, fonts, c, ... }:
let
  inherit (tokens)
    radius
    opacity
    layout
    ;

  glow = c.glowCss c.edge;

  # The rounded, glowing "pill" every bar module sits in.
  pill = ''
    background: alpha(@base01, ${toString opacity.panel});
    border: 1px solid alpha(@${c.edge}, 0.24);

    box-shadow:
      ${glow};

    border-radius: ${toString radius.pill}px;
  '';
in
{
  css = ''
    * {
      border: none;

      font-size: ${toString fonts.sizes.desktop}pt;
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

      border: 1px solid alpha(@${c.edge}, 0.18);
      border-width: 0px;
      border-radius: 0px;
      border-bottom: none;
      padding: 8px 20px;
      min-height: ${toString layout.bar.height}px;
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

    /* Driven by the cpu module's `states`, so a busy machine is legible from
       the colour alone. */
    #cpu.warning {
      color: @${c.slotOf "warn"};
    }

    #cpu.critical {
      color: @${c.slotOf "err"};
    }

    /* On screen somewhere -- this output or the other one. Outlined, not
       filled: the fill below belongs to the screen the bar is actually on. */
    #workspaces button.visible {
      color: @${c.slotOf "secondary"};
      box-shadow: inset 0 0 0 1px alpha(@${c.edge}, 0.45);
    }

    /* Where the keyboard is. waybar computes .active from the *globally* focused
       workspace, so it lands on the same button on every bar -- on a second
       monitor that means both bars claim you are on a workspace only one of them
       is showing. Marked, not filled, for exactly that reason. */
    #workspaces button.active {
      color: @${c.slotOf "primary"};
      box-shadow: inset 0 0 0 2px @${c.slotOf "primary"};
    }

    /* What *this* bar's monitor is displaying. .hosting-monitor is the only
       class waybar scopes to the bar's own output, so it is the one that can
       answer "where am I" on a multi-monitor desktop. Two classes, so it beats
       the single-class rules above regardless of source order. */
    #workspaces button.visible.hosting-monitor {
      color: @base00;

      border: none;
      border-radius: ${toString radius.pill}px;

      background: linear-gradient(
        135deg,
        @${c.slotOf "primary"},
        @${c.slotOf "secondary"}
      );

      box-shadow: ${c.glowCss (c.slotOf "primary")};

      min-width: 50px;
    }

    /* This screen, and the keyboard too. */
    #workspaces button.active.hosting-monitor {
      color: @base00;

      border: none;
      border-radius: ${toString radius.pill}px;

      background: linear-gradient(
        135deg,
        @${c.slotOf "primary"},
        @${c.slotOf "secondary"}
      );

      box-shadow: ${c.glowCss (c.slotOf "primary")};

      min-width: 50px;
    }
  '';

  # Load ramp, quiet -> busy, for the cpu module's click-through view (see
  # bar/waybar/cpu.nix -- the resting format is a glyph and a percentage).
  #
  # It is a click-through rather than the default because none of this fixes the
  # resting case: sixteen cores at rest all render the same 1/8 block on the text
  # baseline, and sixteen identical marks in a row is a dashed rule no matter how
  # they are coloured. Dimming the two idle steps was one attempt and widening
  # the columns with letter_spacing (Pango, in 1024ths of a point) was another;
  # both help under load and neither helps at idle, because the shape is what is
  # wrong. Behind a click the ramp is being read deliberately, which is the one
  # context where sixteen columns earn their space.
  cpuFormatIcons =
    map (
      pair: "<span letter_spacing='1536' color='${c.hex (builtins.head pair)}'>${builtins.elemAt pair 1}</span>"
    ) [
      [ "base03" "▁" ]
      [ "base04" "▂" ]
      [ (c.slotOf "ok") "▃" ]
      [ (c.slotOf "ok") "▄" ]
      [ (c.slotOf "info") "▅" ]
      [ (c.slotOf "warn") "▆" ]
      [ (c.slotOf "secondary") "▇" ]
      [ (c.slotOf "primary") "█" ]
    ];

  # The clock is the module the eye lands on first, so it is typeset rather than
  # printed: the digits carry the weight and the meridiem drops back to a small
  # accent-coloured suffix instead of sitting at the same size as the time. The
  # old format was one flat run of same-size, same-colour glyphs.
  #
  # The Pango markup goes *inside* the chrono spec. Everything in there that is
  # not a % escape passes through strftime as literal text, so the span survives
  # to the label, where waybar renders it as markup.
  clockFormat = "{:%I:%M<span size='small' foreground='${c.accentHex "secondary"}'> %p</span>}";

  # The click-through long form: same trick, roles swapped -- here the date is
  # the subject and the 24h time is the accent.
  #
  # Both strings have to *open* with a % escape. fmt parses the chrono spec
  # itself and rejects one that starts with literal text ("no '%' at start of
  # chrono-specs"), which waybar reports to its log and renders as an empty
  # module -- so the span cannot be wrapped around the whole thing.
  clockFormatAlt = "{:%A, %B %d<span foreground='${c.accentHex "secondary"}'>  %R</span>}";

  calendarFormat = {
    months = "<span color='${c.hex "base0D"}'><b>{}</b></span>";
    days = "<span color='${c.hex "base05"}'><b>{}</b></span>";
    weeks = "<span color='${c.accentHex "ok"}'><b>W{}</b></span>";
    weekdays = "<span color='${c.accentHex "warn"}'><b>{}</b></span>";
    today = "<span color='${c.accentHex "primary"}'><b><u>{}</u></b></span>";
  };
}
