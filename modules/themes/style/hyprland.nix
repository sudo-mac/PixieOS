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
    layout
    shadow
    ;

  a = slot: byte: "rgba(${c.hexA slot byte})";

  # Only emitted when the theme opts in. A theme that uses glow instead of a
  # cast shadow leaves hyprland's own default alone rather than switching it
  # off, so promoting this token changed nothing for existing themes.
  #
  # `range` is its own token rather than `x * 3`, which is what it used to be.
  # Deriving the spread from the offset makes the two inseparable: a shadow that
  # sits almost under its window (a small offset) could only ever be a tight one,
  # and a shadow with no offset at all -- the honest way to say "this surface is
  # lifted off the wallpaper, not lit from a corner" -- came out as no shadow.
  # Kimberly wants a wide, barely-offset one, which the old form could not spell.
  #
  # The alpha likewise comes from `shadow.a` instead of being pinned at 255, so
  # one token decides the shadow's weight for hyprland and for GTK (via
  # lib.nix's depthCss) rather than the two renderers disagreeing.
  shadowLua =
    if !shadow.enable then
      ""
    else
      ''
        		shadow = {
        			enabled = true,
        			range = ${toString shadow.range},
        			render_power = ${toString shadow.power},
        			offset = "${toString shadow.x} ${toString shadow.y}",
        			color = "rgba(${c.withAlpha shadow.color shadow.a})",
        		},
      '';

  # How long each leaf takes, in the deciseconds hyprland reads as `speed`.
  #
  # Pulled out of the animation block so a motion family can differ in *rhythm*
  # and not only in tempo: a family scales the whole table by `rate`, and may
  # override any single entry to make, say, an opening window linger while its
  # neighbours reflow instantly. Before this existed a family could only make
  # everything uniformly faster, which is why "snap" read as cybergirl in a
  # hurry rather than as a different theme.
  baseDurations = {
    global = 10;
    border = 4;
    borderangle = 30;

    windows = 2.2;
    windowsIn = 2;
    windowsOut = 1.6;
    windowsMove = 2.2;

    fade = 3.03;
    fadeIn = 1.73;
    fadeOut = 1.46;
    fadeSwitch = 1.73;
    fadeShadow = 1.73;
    fadeDim = 1.73;
    fadeDpms = 1.73;
    fadePopups = 1.5;
    fadePopupsIn = 1.5;
    fadePopupsOut = 1.3;

    layers = 3.81;
    layersIn = 4;
    layersOut = 1.5;
    fadeLayers = 1.79;
    fadeLayersIn = 1.79;
    fadeLayersOut = 1.39;

    workspaces = 2.5;
    workspacesIn = 2.5;
    workspacesOut = 2.5;

    specialWorkspace = 2.3;
    specialWorkspaceIn = 2.3;
    specialWorkspaceOut = 2;

    zoomFactor = 7;
  };

  # The theme's motion feel.
  #
  #   smooth -- long eased travel; what cybergirl wants behind its blur.
  #   snap   -- the same shapes, harder and faster.
  #   spray  -- kimberly's: overshoot, vertical travel, panels that pop rather
  #             than fade. A family in its own right, not a diff against smooth.
  #
  # Every family names a curve for every role the animation block below asks for
  # and a style for every leaf that takes one, so switching family never leaves a
  # leaf pointing at a bezier or a style another family defined.
  motion =
    let
      smooth = {
        rate = 1.0;
        ease = "easeOutQuint";
        enter = "quick";
        exit = "easeOutQuint";
        snap = "quick";
        linear = "almostLinear";

        # The curve a workspace slide travels on. Named separately from `linear`
        # because it is a literal bezier name, not a role: a slide that eases
        # over this distance looks like it is dragging.
        travel = "linear";

        popin = "92%";
        workspace = "slide";
        special = "slidefadevert 15%";
        layerIn = "fade";
        layerOut = "fade";
        spin = true;
        durations = { };
        curves = ''
          hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
          hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
          hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
          hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
        '';
      };

      snap = smooth // {
        # It used to be 0.45, which put the whole family under 100ms; paired with
        # a curve that is 97% travelled by the halfway point, that is not a snap
        # but a teleport followed by three frames of subpixel crawl. 0.8 keeps
        # this family clearly faster than smooth while leaving enough frames for
        # the motion to actually read.
        rate = 0.8;

        # A hard-out curve with a little overshoot at the end -- the panel lands
        # and settles rather than easing to a stop. Without the overshoot (the
        # old snapOut ended flat at 1.0) the tail is dead time.
        ease = "snapOut";
        enter = "snapIn";
        exit = "snapExit";
        snap = "snapOut";
        linear = "snapOut";
        travel = "linear";

        # 100% is *no* scale delta, so the popin style was a no-op and windows
        # simply blinked into existence. 86% is a visible slap-down.
        popin = "86%";
        workspace = "slidefade 15%";
        special = "slidevert";

        # A 30-decisecond border spin is the opposite of a hard cut.
        spin = false;
        curves = ''
          hl.curve("snapOut", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
          hl.curve("snapIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
          hl.curve("snapExit", { type = "bezier", points = { { 0.3, -0.2 }, { 0, 1 } } })
          hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
        '';
      };

      # Kimberly. She is a Bushinryu student who fights out of handsprings and
      # tags the wall on her way past -- front-footed, airborne, never gliding --
      # so this family is built on three ideas cybergirl's has none of:
      #
      #   overshoot   a window is thrown at the screen, lands past its mark and
      #               settles, instead of easing to a stop. `slap` is the classic
      #               easeOutBack; `yank` is its mirror, pulling back before the
      #               window leaves.
      #   vertical    workspaces travel up and down, not sideways. It is the
      #               single clearest way to tell this desktop from cybergirl's
      #               at a glance, and it is the axis she actually moves on.
      #   popped      the bar, the launcher and the notification stack scale in
      #               like a sticker being pressed down. cybergirl fades them,
      #               which is the one gesture a sticker never makes.
      #
      # It is written out in full rather than as `smooth // { ... }` on purpose:
      # that is what left `snap` sharing cybergirl's fades, its horizontal
      # workspace slide and its layer geometry, which is most of why this theme
      # felt like the other one running fast.
      spray = {
        rate = 1.0;
        ease = "tag";
        enter = "slap";
        exit = "yank";
        snap = "tag";
        linear = "flat";
        travel = "tag";

        # A deep popin, because the overshoot needs somewhere to travel from.
        # At snap's 86% the throw has no room to read.
        popin = "72%";

        workspace = "slidevert";

        # The scratchpad crosses the other axis, so it can never be mistaken for
        # an ordinary workspace switch.
        special = "slidefade 20%";

        layerIn = "popin 80%";
        layerOut = "popin 90%";

        spin = false;

        # Fast where she is fast and slow where the overshoot has to be seen.
        # windowsIn is the longest thing in the family and windowsOut the
        # shortest: she commits to an entrance and vanishes out of one.
        durations = {
          global = 8;
          border = 2.5;

          windows = 3;
          windowsIn = 3.4;
          windowsOut = 1.8;
          windowsMove = 2.6;

          fade = 2.2;
          fadeIn = 1.4;
          fadeOut = 1.1;
          fadeSwitch = 1.4;
          fadeShadow = 1.4;
          fadeDim = 1.4;
          fadeDpms = 1.4;
          fadePopups = 1.2;
          fadePopupsIn = 1.2;
          fadePopupsOut = 1.0;

          layers = 3;
          layersIn = 3.2;
          layersOut = 1.8;
          fadeLayers = 1.5;
          fadeLayersIn = 1.5;
          fadeLayersOut = 1.2;

          workspaces = 3.2;
          workspacesIn = 3.2;
          workspacesOut = 3.2;

          specialWorkspace = 2.6;
          specialWorkspaceIn = 2.6;
          specialWorkspaceOut = 2;

          zoomFactor = 5;
        };

        curves = ''
          -- easeOutBack. Overshoots 1.0 near the end and settles back, which is
          -- what turns a scale-up into a throw.
          hl.curve("slap", { type = "bezier", points = { { 0.34, 1.56 }, { 0.64, 1 } } })

          -- Its mirror: winds back below the start before it goes.
          hl.curve("yank", { type = "bezier", points = { { 0.36, 0 }, { 0.66, -0.56 } } })

          -- The workhorse. Front-loads the travel hard and lands flat, so a
          -- slide reads as a dash rather than a drift.
          hl.curve("tag", { type = "bezier", points = { { 0.05, 0.75 }, { 0.1, 1 } } })

          hl.curve("flat", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
        '';
      };

      families = { inherit smooth snap spray; };
    in
    families.${layout.window.motion} or smooth;

  durations = baseDurations // motion.durations;

  # Scale a base duration by the motion family's rate, rounded to 2dp so the
  # generated Lua stays readable.
  f =
    base:
    let
      scaled = base * motion.rate;
      hundredths = builtins.floor (scaled * 100.0 + 0.5);
    in
    if hundredths / 100 * 100 == hundredths then
      toString (hundredths / 100)
    else
      "${toString (hundredths / 100)}.${
        let
          r = hundredths - (hundredths / 100 * 100);
        in
        if r < 10 then "0${toString r}" else toString r
      }";

  # A leaf's duration: the family's table, scaled by its rate.
  d = leaf: f durations.${leaf};
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
    		layout = "${layout.window.engine}",

    		col = {
    			active_border = { colors = { "${a border.from tokens.alpha.full}", "${a border.to tokens.alpha.full}" }, angle = ${toString border.angle} },
    			inactive_border = "${a border.inactive tokens.alpha.medium}",
    		},
    	},

    	decoration = {
    		rounding = ${toString radius.window},
    		active_opacity = ${toString opacity.active},
    		inactive_opacity = ${toString opacity.inactive},
    		fullscreen_opacity = 1.0,

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

  # Whether to blur behind the bar is a theme decision, not a static one, so the
  # layer rule is generated here rather than sitting in rules.lua: a continuous
  # strip wants the desktop softened behind its translucent fill, while an island
  # bar wants the strip left alone so the wallpaper reads between the islands.
  # Emitted only in the continuous case -- unblurred is hyprland's default.
  barLayerRule =
    if layout.bar.islands then
      ""
    else
      ''
        hl.layer_rule({
        	name = "waybar-blur",
        	match = { namespace = "waybar" },
        	blur = true,
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

    ${motion.curves}

    -- Every leaf hyprland exposes is named explicitly. An unset leaf inherits
    -- its parent's speed and bezier, so the handful that used to be left out --
    -- windowsMove, the scratchpad, the popup and dim fades -- silently ran on
    -- `global`'s tempo and hyprland's stock bezier while everything around them
    -- ran on the theme's. That mismatch is most of what read as broken motion.
    hl.animation({ leaf = "global", enabled = true, speed = ${d "global"}, bezier = "default" })

    -- Borders
    hl.animation({ leaf = "border", enabled = true, speed = ${d "border"}, bezier = "${motion.ease}" })
    hl.animation({ leaf = "borderangle", enabled = ${
      if motion.spin then "true" else "false"
    }, speed = ${d "borderangle"}, bezier = "${motion.ease}", style = "once" })

    -- Windows. In and out get their own curves so a window does not leave by
    -- the same motion it arrived with.
    hl.animation({ leaf = "windows", enabled = true, speed = ${d "windows"}, bezier = "${motion.snap}" })
    hl.animation({ leaf = "windowsIn", enabled = true, speed = ${d "windowsIn"}, bezier = "${motion.enter}", style = "popin ${motion.popin}" })
    hl.animation({ leaf = "windowsOut", enabled = true, speed = ${d "windowsOut"}, bezier = "${motion.exit}", style = "popin ${motion.popin}" })
    hl.animation({ leaf = "windowsMove", enabled = true, speed = ${d "windowsMove"}, bezier = "${motion.snap}" })

    -- Fades. windowsMove above reflows the neighbours of every open and close,
    -- so these have to sit in the same tempo or the two halves of one event
    -- visibly disagree.
    hl.animation({ leaf = "fade", enabled = true, speed = ${d "fade"}, bezier = "${motion.snap}" })
    hl.animation({ leaf = "fadeIn", enabled = true, speed = ${d "fadeIn"}, bezier = "${motion.linear}" })
    hl.animation({ leaf = "fadeOut", enabled = true, speed = ${d "fadeOut"}, bezier = "${motion.linear}" })
    hl.animation({ leaf = "fadeSwitch", enabled = true, speed = ${d "fadeSwitch"}, bezier = "${motion.linear}" })
    hl.animation({ leaf = "fadeShadow", enabled = true, speed = ${d "fadeShadow"}, bezier = "${motion.linear}" })
    hl.animation({ leaf = "fadeDim", enabled = true, speed = ${d "fadeDim"}, bezier = "${motion.linear}" })
    hl.animation({ leaf = "fadeDpms", enabled = true, speed = ${d "fadeDpms"}, bezier = "${motion.linear}" })
    hl.animation({ leaf = "fadePopups", enabled = true, speed = ${d "fadePopups"}, bezier = "${motion.linear}" })
    hl.animation({ leaf = "fadePopupsIn", enabled = true, speed = ${d "fadePopupsIn"}, bezier = "${motion.linear}" })
    hl.animation({ leaf = "fadePopupsOut", enabled = true, speed = ${d "fadePopupsOut"}, bezier = "${motion.linear}" })

    -- Layer surfaces: the bar, the launcher, the notification stack. The style
    -- is the family's, not a constant -- a theme whose panels are stickers wants
    -- them pressed down, and one whose panels are glass wants them faded up.
    hl.animation({ leaf = "layers", enabled = true, speed = ${d "layers"}, bezier = "${motion.ease}" })
    hl.animation({ leaf = "layersIn", enabled = true, speed = ${d "layersIn"}, bezier = "${motion.enter}", style = "${motion.layerIn}" })
    hl.animation({ leaf = "layersOut", enabled = true, speed = ${d "layersOut"}, bezier = "${motion.exit}", style = "${motion.layerOut}" })
    hl.animation({ leaf = "fadeLayers", enabled = true, speed = ${d "fadeLayers"}, bezier = "${motion.linear}" })
    hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = ${d "fadeLayersIn"}, bezier = "${motion.linear}" })
    hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = ${d "fadeLayersOut"}, bezier = "${motion.linear}" })

    -- Workspaces. The travel curve is the family's: cybergirl rides a slide out
    -- flat, because an eased slide over this distance looks like it is dragging,
    -- while kimberly front-loads it so the same distance reads as a dash.
    hl.animation({ leaf = "workspaces", enabled = true, speed = ${d "workspaces"}, bezier = "${motion.travel}", style = "${motion.workspace}" })
    hl.animation({ leaf = "workspacesIn", enabled = true, speed = ${d "workspacesIn"}, bezier = "${motion.travel}", style = "${motion.workspace}" })
    hl.animation({ leaf = "workspacesOut", enabled = true, speed = ${d "workspacesOut"}, bezier = "${motion.travel}", style = "${motion.workspace}" })

    -- The scratchpad (SUPER+S) crosses the axis the workspaces travel on, so it
    -- is legible as an overlay and not as another workspace.
    hl.animation({ leaf = "specialWorkspace", enabled = true, speed = ${d "specialWorkspace"}, bezier = "${motion.ease}", style = "${motion.special}" })
    hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = ${d "specialWorkspaceIn"}, bezier = "${motion.enter}", style = "${motion.special}" })
    hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = ${d "specialWorkspaceOut"}, bezier = "${motion.exit}", style = "${motion.special}" })

    hl.animation({ leaf = "zoomFactor", enabled = true, speed = ${d "zoomFactor"}, bezier = "${motion.snap}" })

    -- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
    hl.config({
    	dwindle = {
    		preserve_split = true, -- You probably want this
    	},
    })

    -- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
    hl.config({
    	master = {
    		-- "master" would make every new window steal the master slot and shuffle
    		-- the layout out from under you.
    		new_status = "slave",
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
