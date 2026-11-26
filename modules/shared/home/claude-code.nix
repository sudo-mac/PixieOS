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

  # The keys Nix owns. Everything else in settings.json (effortLevel, model,
  # permissions, ...) belongs to Claude Code, which has to be able to write the
  # file itself -- a home.file symlink into /nix/store is read-only (EROFS on
  # /effort, /config, "always allow").
  managedSettings = {
    theme = style.settingsTheme;
    agentPushNotifEnabled = true;
    inputNeededNotifEnabled = true;
    statusLine = {
      type = "command";
      command = "~/.claude/statusline.sh";
    };
  };
  managedJson = pkgs.writeText "claude-managed-settings.json" (builtins.toJSON managedSettings);
in
{
  options.alienix.home.claude-code.enable = mkEnableOption "Declarative Claude Code settings and statusline";

  config = mkIf config.alienix.home.claude-code.enable {
    # settings.json is a real, writable file. On every switch the Nix-owned keys
    # above are merged over whatever is there (Nix wins on those keys only).
    home.activation.claudeSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      claudeDir="$HOME/.claude"
      settings="$claudeDir/settings.json"
      jq="${pkgs.jq}/bin/jq"

      run mkdir -p "$claudeDir"

      existing="{}"
      if [ -e "$settings" ] && "$jq" -e 'type == "object"' "$settings" >/dev/null 2>&1; then
        existing="$(cat "$settings")"
      fi
      # Old home.file store symlink: drop the link, keep its contents (read above).
      if [ -L "$settings" ]; then
        run rm -f "$settings"
      fi

      merged="$(printf '%s' "$existing" | "$jq" -s '.[0] * .[1]' - ${managedJson})"
      if [ -z "''${DRY_RUN:-}" ]; then
        tmp="$(mktemp "$claudeDir/.settings.json.XXXXXX")"
        printf '%s\n' "$merged" > "$tmp"
        chmod 644 "$tmp"
        mv -f "$tmp" "$settings"
      else
        echo "Would merge Nix-managed keys into $settings"
      fi
    '';

    # Palette is substituted in from the active theme, so the statusline can
    # never drift from the rest of the desktop the way the hand-copied hex
    # block it used to carry did.
    home.file.".claude/statusline.sh" = {
      source = pkgs.replaceVars ./claude-statusline.sh style.colors;
      executable = true;
    };
  };
}
