{ pkgs, ... }:
{
  xdg.configFile."rofi/scripts/media-player.sh".source = pkgs.writeShellScript "rofi-media-player" ''
    #!/usr/bin/env bash
    if [ -n "$1" ]; then
      case "$1" in
        *Previous*) playerctl previous ;;
        *Next*) playerctl next ;;
        *"Play / Pause"*) playerctl play-pause ;;
      esac
      exit 0
    fi

    STATUS=$(playerctl status 2>/dev/null)
    if [ -z "$STATUS" ]; then
      echo "Nothing is playing"
      exit 0
    fi

    ARTIST=$(playerctl metadata artist 2>/dev/null)
    TITLE=$(playerctl metadata title 2>/dev/null)
    ALBUM=$(playerctl metadata album 2>/dev/null)

    echo "$TITLE"
    echo "$ARTIST — $ALBUM ($STATUS)"
    echo "⏮  Previous"
    echo "⏯  Play / Pause"
    echo "⏭  Next"
  '';

  programs.waybar.settings.mainBar.mpris = {
    format = "{status_icon} {dynamic}";
    status-icons = {
      playing = "";
      paused = "";
      stopped = "";
    };
    max-length = 35;
  };
}
