{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  theme = config.alienix.theme.active;
  style = theme.style.regreet theme;
in
{
  # There was no display manager at all -- login was a bare TTY between a themed
  # GRUB and a themed desktop. regreet is a GTK greeter for greetd, so it takes
  # the same palette, font, cursor and wallpaper as everything else.
  config = mkIf (theme.components.greeter == "regreet") {
    # stylix ships its own regreet target, but it writes to the pre-rename
    # `programs.regreet` path, which both emits a deprecation warning on every
    # evaluation and makes it a second author for settings the theme owns.
    # Same reasoning as the hyprlock and dunst targets.
    stylix.targets.regreet.enable = false;

    # regreet discovers sessions by scanning share/wayland-sessions on
    # XDG_DATA_DIRS, and nothing was putting hyprland.desktop there --
    # programs.hyprland only registers the session with
    # services.displayManager.sessionPackages, which the greeter never reads.
    # Without this the greeter comes up with an empty session list and there is
    # nothing to log into.
    environment = {
      systemPackages = [ config.services.displayManager.sessionData.desktops ];

      # systemPackages alone is not enough: system-path only links the subdirs
      # named here, and share/wayland-sessions is not one of the defaults.
      pathsToLink = [
        "/share/wayland-sessions"
        "/share/xsessions"
      ];
    };

    services.displayManager.regreet = {
      enable = true;

      font = {
        inherit (theme.fonts.ui) package name;
        size = theme.fonts.sizes.desktop;
      };

      cursorTheme = {
        inherit (theme.cursor) package name;
      };

      iconTheme = {
        inherit (theme.icons) package name;
      };

      # adw-gtk3 gives the widgets a sane dark base; the theme's CSS on top is
      # what makes the card look like the rest of the desktop.
      theme = {
        package = pkgs.adw-gtk3;
        name = "adw-gtk3";
      };

      extraCss = style.css;

      settings = {
        background = style.background;
        GTK.application_prefer_dark_theme = theme.meta.polarity == "dark";
      };
    };
  };
}
