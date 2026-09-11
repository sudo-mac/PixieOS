# Presentation for the launcher: a .rasi stylesheet.
{
  tokens,
  fonts,
  icons,
  c,
  ...
}:
let
  inherit (tokens) radius layout;
  inherit (layout) launcher;

  grid = launcher.mode == "grid";
in
{
  iconTheme = icons.name;

  rasi = ''
    * {
      font: "${fonts.ui.name} ${toString fonts.sizes.desktop}";

      base00: ${c.hex "base00"};
      base01: ${c.hex "base01"};
      base04: ${c.hex "base04"};
      base05: ${c.hex "base05"};
      accent: ${c.accentHex "primary"};
      edge:   ${c.hex c.edge};

      background: transparent;
      foreground: @base05;
      text-color: inherit;
    }

    window {
      width: ${toString launcher.width}px;
      border: ${toString tokens.border.width}px;
      border-radius: ${toString radius.card}px;
      padding: 14px;

      border-color: @edge;
      background-color: @base00;
    }

    mainbox {
      spacing: 12px;
      background-color: transparent;
    }

    inputbar {
      background-color: @base01;
      border-radius: ${toString radius.pill}px;
      padding: 10px 12px;
      spacing: 10px;
      children: [ prompt, entry ];
    }

    /* Before the first keystroke the inputbar is the largest thing in the
       launcher, so it needs something in it: the prompt glyph (set by the
       component module's display-drun) plus a placeholder. Empty, it read as an
       unfinished box rather than a search field.

       `cursor` used to be set here to a colour. It is rofi's *pointer shape*
       property, so it parsed, did nothing, and left the caret unstyled. */
    entry {
      background-color: transparent;
      text-color: @accent;
      cursor: text;
      placeholder: "Type to search";
      placeholder-color: @base04;
    }

    prompt {
      background-color: transparent;
      text-color: @edge;
    }

    case-indicator { background-color: transparent; }

    textbox {
      background-color: @base00;
      text-color: inherit;
    }

    listview {
      background-color: @base00;
      fixed-height: false;
      columns: ${toString launcher.columns};
      lines: ${toString launcher.lines};
      spacing: 10px;
      scrollbar: false;
      padding: 2px;
    }

    element {
      background-color: @base01;
      border-radius: ${toString radius.pill}px;
      padding: 10px 12px;
      text-color: @base05;
      ${
        # A grid stacks the icon over its label and centres the pair; a list
        # keeps them side by side. Everything else about an element is shared.
        if grid then
          ''
            orientation: vertical;
                  spacing: 8px;
                  children: [ element-icon, element-text ];''
        else
          ""
      }
    }

    element-icon {
      background-color: transparent;
      size: ${toString launcher.iconSize}px;
      ${if grid then "horizontal-align: 0.5;" else "margin: 0px 10px 0px 0px;"}
    }

    element-text {
      background-color: transparent;
      expand: true;
      vertical-align: 0.5;
      ${if grid then "horizontal-align: 0.5;" else ""}
    }

    element selected {
      background-color: @accent;
      text-color: @base00;
    }
  '';
}
