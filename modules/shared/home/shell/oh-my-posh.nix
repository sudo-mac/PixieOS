{
  pkgs,
  lib,
  config,
  ...
}:
let
  colors = config.lib.stylix.colors;
  pua = code: builtins.fromJSON ''"\u${code}"'';

  bg = "#${colors.base00}";
  bgAlt = "#${colors.base01}";
  bgHighlight = "#${colors.base02}";
  muted = "#${colors.base04}";
  bright = "#${colors.base07}";

  pink = "#${colors.base08}";
  yellow = "#${colors.base0A}";
  mint = "#${colors.base0B}";
  cyan = "#${colors.base0C}";
  blue = "#${colors.base0D}";
  purple = "#${colors.base0E}";

  capL = pua "e0b6";
  capR = pua "e0b4";
  divider = pua "e0b0";
in
{
  programs.oh-my-posh =
    {
      enableBashIntegration = true;
      enableZshIntegration = true;

      settings = {
        "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
        version = 4;

        blocks = [
          {
            type = "prompt";
            alignment = "left";
            segments = [
              {
                type = "session";
                style = "powerline";
                leading_diamond = capL;
                powerline_symbol = divider;
                background = purple;
                foreground = bg;
                template = " {{ .UserName }}@{{ .HostName }} ";
              }
              {
                type = "path";
                style = "powerline";
                powerline_symbol = divider;
                background = blue;
                foreground = bg;
                properties = {
                  style = "agnoster_short";
                  max_depth = 3;
                  home_icon = "~";
                };
                template = " 󰉋 {{ .Path }} ";
              }
              {
                type = "git";
                style = "powerline";
                powerline_symbol = divider;
                background = mint;
                background_templates = [
                  "{{ if or (.Working.Changed) (.Staging.Changed) }}${yellow}{{ end }}"
                  "{{ if or (gt .Ahead 0) (gt .Behind 0) }}${cyan}{{ end }}"
                ];
                foreground = bg;
                properties = {
                  branch_icon = "󰊢 ";
                  fetch_status = true;
                };
                template = " {{ .HEAD }}{{ if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }} 󰏫 {{ .Working.String }}{{ end }}{{ if .Staging.Changed }} 󰐕 {{ .Staging.String }}{{ end }} ";
              }
              {
                type = "root";
                style = "powerline";
                powerline_symbol = divider;
                background = pink;
                foreground = bright;
                template = " 󰒃 ";
              }
              {
                type = "executiontime";
                style = "powerline";
                powerline_symbol = divider;
                background = bgHighlight;
                foreground = muted;
                properties = {
                  threshold = 500;
                  style = "round";
                };
                template = " 󰦖 {{ .FormattedMs }} ";
              }
              {
                type = "text";
                style = "diamond";
                trailing_diamond = capR;
                background = bgHighlight;
                foreground = muted;
                template = " ─";
              }
            ];
          }
          {
            type = "prompt";
            alignment = "right";
            segments = [
              {
                type = "time";
                style = "diamond";
                leading_diamond = capL;
                trailing_diamond = "${capR} ";
                background = bgAlt;
                foreground = muted;
                properties = {
                  time_format = "15:04";
                };
                template = " 󰥔 {{ .CurrentDate | date .Format }} ";
              }
            ];
          }
          {
            type = "prompt";
            alignment = "left";
            newline = true;
            segments = [
              {
                type = "text";
                style = "plain";
                foreground = blue;
                template = "╰─";
              }
              {
                type = "status";
                style = "plain";
                foreground = cyan;
                foreground_templates = [
                  "{{ if gt .Code 0 }}${pink}{{ end }}"
                ];
                properties = {
                  always_enabled = true;
                };
                template = "❯ ";
              }
            ];
          }
        ];
      };
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      enable = true;
    };
}
