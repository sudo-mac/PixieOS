{
  programs.waybar = {
    settings.mainBar.bluetooth = {
      # A glyph, not the adapter or device name, for the reason spelled out in
      # network.nix: the right-hand group only gets half the bar's width, and a
      # paired device's alias is as long as an SSID. Everything worth reading --
      # which adapter, what is connected, how much charge a controller or a pair
      # of headphones has left -- is in the tooltip below.
      format = "󰂯";

      # Adapter present but soft-blocked, and adapter powered off. Same glyph:
      # from the bar's point of view the two are one state, "no bluetooth", and
      # the tooltip names which one it is.
      format-disabled = "󰂲";
      format-off = "󰂲";

      # Distinct from the idle glyph, so "on" and "in use" are not the same mark.
      format-connected = "󰂱";

      tooltip-format = "{controller_alias}\t{controller_address}";
      tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
      tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";

      # bluez only exposes a device's battery on its Battery1 interface, which
      # is behind its Experimental flag (turned on in nixos/system/default.nix
      # for this line's sake). Waybar uses this variant of the enumerate line
      # for devices that publish one and the plain variant above for the rest,
      # so the tooltip degrades to just names if the flag ever goes away.
      tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";

      on-click = "blueman-manager";
    };
  };
}
