{
  programs.waybar = {
    settings.mainBar.network = {
      interface = "wlp3s0";
      format = "{ifname}";

      # A signal-strength glyph, not the SSID. The network name is the longest
      # string in the bar by a wide margin -- around 250px for this one -- and
      # waybar centres the middle group on the bar as a whole, so the right-hand
      # group only ever gets half the screen minus the clock. On the 1360px
      # output that was not enough and the group ellipsized into "Wifi …" and
      # "100% …". The SSID and the exact percentage are both one hover away in
      # the tooltip below.
      format-wifi = "{icon}";
      format-icons = [
        "󰤯"
        "󰤟"
        "󰤢"
        "󰤥"
        "󰤨"
      ];

      format-ethernet = "󰊗";
      format-disconnected = "";
      tooltip-format = "{ifname} via {gwaddr} 󰊗";
      tooltip-format-wifi = "{essid} ({signalStrength}%) ";
      tooltip-format-ethernet = "{ifname} — {ipaddr}/{cidr} ";
      tooltip-format-disconnected = "Disconnected";
      max-length = 50;
      on-click = "nm-connection-editor";
    };
  };
}
