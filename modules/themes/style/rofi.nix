# Presentation for the launcher: a .rasi stylesheet.
{ tokens, fonts, icons, c, ... }:
let
  inherit (tokens) radius;
in
{
  iconTheme = icons.name;

  rasi = ''
    * {
      font: "${fonts.ui.name} 16";

      base00: ${c.hex "base00"};
      base01: ${c.hex "base01"};
      base05: ${c.hex "base05"};
      accent: ${c.accentHex "primary"};
      edge:   ${c.hex "base0D"};

      background: transparent;
      foreground: @base05;
      text-color: inherit;
    }

    window {
      width: 720px;
      border: 2px;
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
    }

    entry {
      background-color: transparent;
      text-color: @accent;
      cursor: @edge;
    }

    prompt {
      background-color: transparent;
    }

    case-indicator { background-color: transparent; }

    textbox {
      background-color: @base00;
      text-color: inherit;
    }

    listview {
      background-color: @base00;
      fixed-height: false;
      lines: 8;
      spacing: 10px;
      scrollbar: false;
      padding: 2px;
    }

    element {
      background-color: @base01;
      border-radius: ${toString radius.pill}px;
      padding: 10px 12px;
      text-color: @base05;
    }

    element-icon {
      background-color: transparent;
      size: 20px;
      margin: 0px 10px 0px 0px;
    }

    element-text {
      background-color: transparent;
      expand: true;
      vertical-align: 0.5;
    }

    element selected {
      background-color: @accent;
      text-color: @base00;
    }
  '';
}
