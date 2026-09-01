# Presentation for the compositor itself. Emits the bodies of the generated
# appearance.lua / animations.lua, so the border gradient, rounding, blur and
# opacities come from tokens rather than hand-copied hex literals.
{ tokens, cursor, c, ... }:
let
  inherit (tokens)
    radius
    border
    blur
    opacity
    gaps
    shadow
    ;

  a = slot: byte: "rgba(${c.hexA slot byte})";

  # Only emitted when the theme opts in. A theme that uses glow instead of a
  # cast shadow leaves hyprland's own default alone rather than switching it
  # off, so promoting this token changed nothing for existing themes.
  shadowLua =
    if !shadow.enable then
      ""
    else
      ''
        		shadow = {
        			enabled = true,
        			range = ${toString (shadow.x * 3)},
        			render_power = 3,
        			offset = "${toString shadow.x} ${toString shadow.y}",
        			color = "${a shadow.color 255}",
        		},
      '';
in
{
  appearance = ''
    hl.config({
    	general = {
    		gaps_in = ${toString gaps.inner},
    		gaps_out = ${toString gaps.outer},
    		border_size = ${toString border.width},
    		resize_on_border = true,
    		allow_tearing = false,
    		layout = "dwindle",

    		col = {
    			active_border = { colors = { "${a border.from tokens.alpha.full}", "${a border.to tokens.alpha.full}" }, angle = ${toString border.angle} },
    			inactive_border = "${a border.inactive tokens.alpha.medium}",
    		},
    	},

    	decoration = {
    		rounding = ${toString radius.window},
    		active_opacity = ${toString opacity.active},
    		inactive_opacity = ${toString opacity.inactive},
    		fullscreen_opacity = 100,

    ${shadowLua}
    		blur = {
    			enabled = ${if blur.enable then "true" else "false"},
    			xray = ${if blur.xray then "true" else "false"},
    			special = false,
    			new_optimizations = true,
    			size = ${toString blur.size},
    			passes = ${toString blur.passes},
    			brightness = 1,
    			noise = ${toString blur.noise},
    			contrast = 1,
    			popups = true,
    			popups_ignorealpha = 0.6,
    			ignore_opacity = false,
    		},
    	},

    	animations = {
    		enabled = true,
    	},

    	-- A wallpaper daemon owns the background (see the theme's wallpaper
    	-- component slot), so hyprland's built-in mascot must never show through.
    	misc = {
    		force_default_wallpaper = 0,
    		disable_hyprland_logo = true,
    	},
    })
  '';

  # Cursor sizing lives here so it can never drift from theme.cursor.size the
  # way the old hand-written 24-vs-32 pair did.
  cursorEnv = ''
    hl.env("XCURSOR_SIZE", "${toString cursor.size}")
    hl.env("HYPRCURSOR_SIZE", "${toString cursor.size}")
  '';

  animations = ''
    -----------------------
    ----- ANIMATIONS ------
    -----------------------

    hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
    hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
    hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
    hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

    hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
    hl.animation({ leaf = "border", enabled = true, speed = 4, bezier = "easeOutQuint" })
    hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "easeOutQuint", style = "once" })
    hl.animation({ leaf = "windows", enabled = true, speed = 2.2, bezier = "quick" })
    hl.animation({ leaf = "windowsIn", enabled = true, speed = 2, bezier = "quick", style = "popin 92%" })
    hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.6, bezier = "quick", style = "popin 92%" })
    hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
    hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
    hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
    hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
    hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
    hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
    hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
    hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
    hl.animation({ leaf = "workspaces", enabled = true, speed = 2.5, bezier = "linear", style = "slide" })
    hl.animation({ leaf = "workspacesIn", enabled = true, speed = 2.5, bezier = "linear", style = "slide" })
    hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2.5, bezier = "linear", style = "slide" })
    hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

    -- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
    hl.config({
    	dwindle = {
    		preserve_split = true, -- You probably want this
    	},
    })

    -- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
    hl.config({
    	master = {
    		new_status = "master",
    	},
    })

    -- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
    hl.config({
    	scrolling = {
    		fullscreen_on_one_column = true,
    	},
    })
  '';
}
