{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.alienix.home.claude-code.enable = mkEnableOption "Declarative Claude Code settings and statusline";

  config = mkIf config.alienix.home.claude-code.enable {
    home.file.".claude/settings.json".text = builtins.toJSON {
      theme = "dark";
      agentPushNotifEnabled = true;
      inputNeededNotifEnabled = true;
      statusLine = {
        type = "command";
        command = "~/.claude/statusline.sh";
      };
    };

    home.file.".claude/statusline.sh".source = ./claude-statusline.sh;
  };
}
