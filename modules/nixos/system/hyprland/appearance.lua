hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 15,
		border_size = 3,
		resize_on_border = true,
		allow_tearing = false,
		layout = "dwindle",

		col = {
			active_border = { colors = { "rgba(4fdfffee)", "rgba(b388ffee)" }, angle = 45 },
			inactive_border = "rgba(163854aa)",
		},
	},

	decoration = {
		rounding = 10,
		active_opacity = 0.75,
		inactive_opacity = 0.8,
		fullscreen_opacity = 100,

		blur = {
			enabled = true,
			xray = true,
			special = false,
			new_optimizations = true,
			size = 14,
			passes = 4,
			brightness = 1,
			noise = 1.0e-2,
			contrast = 1,
			popups = true,
			popups_ignorealpha = 0.6,
			ignore_opacity = false,
		},
	},

	animations = {
		enabled = true,
	},
})

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
-- 	ecosystem = {
-- 		enforce_permissions = true,
-- 	},
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
