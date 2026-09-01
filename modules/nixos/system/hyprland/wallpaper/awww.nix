{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  theme = config.alienix.theme.active;
  inherit (theme) c;

  # The client refuses to talk to a daemon that isn't listening yet, so wait for
  # it before pushing the image. The old start.sh only did `swww-daemon &` and
  # leaned on the daemon's cache to restore whatever was last set by hand --
  # naming the image here is what makes the wallpaper follow the active theme.
  wallpaperDaemon = pkgs.writeShellScriptBin "wallpaper-daemon" ''
    ${pkgs.awww}/bin/awww-daemon &
    until ${pkgs.awww}/bin/awww query >/dev/null 2>&1; do sleep 0.1; done
    exec ${pkgs.awww}/bin/awww img ${theme.wallpaper} \
      --resize crop \
      --fill-color ${c.hexA "base00" 255} \
      --transition-type grow
  '';
in
{
  config = mkIf (theme.components.wallpaper == "awww") {
    home.packages = [
      pkgs.awww
      wallpaperDaemon
    ];
  };
}
