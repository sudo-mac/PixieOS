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

  cfg = config.alienix.system.greeter;

  greeter = config.services.displayManager.regreet.package;
  hyprland = config.programs.hyprland.package;

  # "This output and nothing else." The catch-all has to come first: hyprland
  # applies monitor rules in order and the last one that matches a given output
  # is the one that sticks, so the named rule reads as an exception to it.
  #
  # Stated this way round -- disable everything, then bring one back -- rather
  # than by naming the outputs to switch off, so that plugging in a monitor the
  # config has never heard of cannot move the login screen.
  monitorRules =
    if cfg.output == null then
      "monitor = , preferred, auto, 1"
    else
      ''
        monitor = , disable
        monitor = ${cfg.output}, preferred, 0x0, 1
      '';

  # The greeter's compositor. Everything decorative is off: the greeter is the
  # only client that will ever connect, it is a single tiled window, and with
  # gaps, borders and rounding at zero that window is exactly the output.
  greeterConf = pkgs.writeText "greeter-hyprland.conf" ''
    ${monitorRules}

    general {
      gaps_in = 0
      gaps_out = 0
      border_size = 0
    }

    decoration {
      rounding = 0

      blur {
        enabled = false
      }

      shadow {
        enabled = false
      }
    }

    animations {
      enabled = false
    }

    misc {
      # Otherwise the half-second before regreet maps its window is hyprland's
      # own wallpaper and logo, which is not this theme.
      disable_hyprland_logo = true
      disable_splash_rendering = true
      force_default_wallpaper = 0

      background_color = rgb(${theme.palette.base00})
    }

    env = XCURSOR_THEME,${theme.cursor.name}
    env = XCURSOR_SIZE,${toString theme.cursor.size}

    # greetd kills the compositor itself once a session starts, so this only
    # matters on the paths that end without one -- reboot, poweroff, or regreet
    # falling over -- where without it hyprland would sit on an empty screen.
    exec-once = ${getExe greeter}; ${hyprland}/bin/hyprctl dispatch exit
  '';
in
{
  options.alienix.system.greeter.output = mkOption {
    type = types.nullOr types.str;
    default = null;
    example = "eDP-1";

    description = ''
      The single output the login screen is confined to, by connector name as
      hyprland spells it. `null` spreads it over every connected output, which
      is what the default compositor does.
    '';
  };

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

    # hyprland in place of cage, which is what the regreet module reaches for by
    # default (`lib.mkDefault`, so this needs no force).
    #
    # cage has no way to say which output it wants. Its surface is every
    # connected output glued into one, so with the laptop panel and the HDMI
    # monitor both up the greeter was drawing into a 3280x1080 canvas: the
    # wallpaper landed in the middle of that and was cut in half by the seam
    # between the two screens. `-m last` is the only knob it has and it picks
    # the output by DRM enumeration order, which on this machine ends
    # DP-1, eDP-1, HDMI-A-1 -- so it would have moved the greeter to the
    # external monitor, not the laptop.
    #
    # hyprland is already in the closure for the session, so this costs nothing
    # to add, and `monitor =` says exactly which screen the login screen is on.
    services.greetd.settings.default_session.command =
      "${pkgs.dbus}/bin/dbus-run-session ${hyprland}/bin/Hyprland --config ${greeterConf}";

    services.displayManager.regreet = {
      enable = true;

      # Upstream lets the Login button submit an empty password box. greetd
      # answers that with pam_authenticate: AUTH_ERR, and regreet's handling of
      # an auth error is to cancel the session -- which tears the form down,
      # rebuilds it from the username stage, and puts a bold red "Login failed:
      # Pam_authenticate: auth_err" above it. Pressing the button before typing
      # is the single easiest thing to do on that screen, and the reward for it
      # looked like the greeter had crashed and recovered.
      #
      # An empty box is not an answer, so it is not sent. --replace-fail rather
      # than --replace so that this fails the build, loudly, the moment upstream
      # touches that line, instead of quietly reverting the behaviour.
      package = pkgs.regreet.overrideAttrs (prev: {
        postPatch = (prev.postPatch or "") + ''
          substituteInPlace src/gui/model.rs --replace-fail \
            'self.send_input(sender, input).await;' \
            'if input.is_empty() { warn!("Ignoring empty auth response"); } else { self.send_input(sender, input).await; }'
        '';
      });

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

        # Stated because regreet's fallback is whatever sys-locale reports,
        # which is the BCP-47 tag `en-US`; chrono wants the POSIX `en_US` and
        # rejects the hyphen, so the clock was logging "Could not parse system
        # locale en-US" once a minute for the whole time the greeter was up.
        widget.clock.locale = "en_US";
      };
    };
  };
}
