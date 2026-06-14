hl.on("hyprland.start", function()
	hl.exec_cmd("terminal")
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("waybar & dunst")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
