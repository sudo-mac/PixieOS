---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		-- Hover focuses. 2 was tried and is wrong: under 2 the cursor only carries
		-- pointer focus, so hovering highlights a window and scrolls it but the
		-- keyboard stays behind on whatever was clicked last -- which is not
		-- focus-follows-mouse, it is focus-follows-click with a hover effect.
		follow_mouse = 1,

		-- ...and this is what 2 was actually reaching for. The complaint against 1
		-- was that a *parked* cursor stole focus: open a window on this monitor
		-- with SUPER+W while the mouse happens to be sitting over the other
		-- screen, and focus slid out from under the new window immediately.
		--
		-- That is refocus-on-anything, not follow-mouse. With mouse_refocus off,
		-- focus moves only when the cursor actually crosses a window boundary, so
		-- a cursor that has not moved cannot take focus from a keybind. Hovering
		-- deliberately still focuses, because that is a boundary crossing.
		mouse_refocus = false,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = false,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
-- hl.device({
-- 	name = "epic-mouse-v1",
-- 	sensitivity = -0.5,
-- })
