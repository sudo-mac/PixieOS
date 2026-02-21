{
  programs.waybar = {
    settings.mainBar.pulseaudio = {
      format = "{volume}% {icon}";
      format-bluetooth = "{volume}% {icon}";
      format-muted = "";
      format-icons = {
        headphones = "";
        handsfree = "";
        headset = "";
        phone = "";
        phone-muted = "";
        portable = "";
        car = "";
        default = [ "" "" ];
      };
      scroll-step = 1;
      on-click = "pavucontrol";
    };
  };
}
