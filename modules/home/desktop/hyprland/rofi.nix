{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  colors = config.lib.stylix.colors;
in {
  programs.rofi = {
    enable = true;
    theme = lib.mkForce "pixieos";
  };

  xdg.configFile."rofi/pixieos.rasi".text = ''
    configuration {
      show-icons: true;
      icon-theme: "Papirus";
      display-drun: " ";
      drun-display-format: "{icon}  {name}";
    }

    * {
      font: "JetBrainsMono Nerd Font Propo 16";

      base00: #${colors.base00};
      base01: #${colors.base01};
      base05: #${colors.base05};
      base08: #${colors.base08};
      base0D: #${colors.base0D};

      background: transparent;
      foreground: @base05;
      text-color: inherit;
    }

    window {
      width: 720px;
      border: 2px;
      border-radius: 18px;
      padding: 14px;

      border-color: @base0D;
      background-color: @base00;
    }

    mainbox {
        spacing: 12px;
        background-color: transparent;
    }

    inputbar {
      background-color: @base01;
      border-radius: 999px;
      padding: 10px 12px;
    }

    entry {
      background-color: transparent;
      text-color: @base08;
      cursor: @base0D;
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
      border-radius: 999px;
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
      background-color: @base08;
      text-color: @base00;
    }
  '';
}
