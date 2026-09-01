{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  theme = config.alienix.theme.active;
  style = theme.style.claude theme;
in
{
  options.alienix.home.claude-code.enable = mkEnableOption "Declarative Claude Code settings and statusline";

  config = mkIf config.alienix.home.claude-code.enable {
    home.file.".claude/settings.json".text = builtins.toJSON {
      theme = style.settingsTheme;
      agentPushNotifEnabled = true;
      inputNeededNotifEnabled = true;
      statusLine = {
        type = "command";
        command = "~/.claude/statusline.sh";
      };
    };

    # Palette is substituted in from the active theme, so the statusline can
    # never drift from the rest of the desktop the way the hand-copied hex
    # block it used to carry did.
    home.file.".claude/statusline.sh" = {
      source = pkgs.replaceVars ./claude-statusline.sh style.colors;
      executable = true;
    };
  };
}
