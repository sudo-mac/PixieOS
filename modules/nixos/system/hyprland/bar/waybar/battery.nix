{
  programs.waybar = {
    settings.mainBar.battery = {
      # Pin the module to this laptop's one real battery and one real adapter.
      #
      # Left unset, waybar scans every directory under /sys/class/power_supply
      # and watches each battery-shaped one for events. A DualSense connected
      # over bluetooth is battery-shaped: hid-playstation publishes
      # ps-controller-battery-<mac> with capacity, status and uevent. When the
      # controller disconnects, that directory is torn down while the module is
      # still walking it, inotify_add_watch on its uevent fails, and the module
      # throws -- out of a worker thread, where nothing catches it, so waybar
      # aborts and the whole bar disappears until the next login.
      #
      # `bat` short-circuits the per-directory checks before the watch is ever
      # added, so the controller is not merely ignored for display, it is never
      # touched. `adapter` matters for the same reason from the other side: the
      # adapter branch has no such filter, and any directory with a `status`
      # file can claim the slot -- including the controller's.
      bat = "BAT1";
      adapter = "ACAD";

      format = "{capacity}% {icon}";
      format-icons = [ "" "" "" "" "" ];
      max-length = 25;

      interval = 60;
      states = {
        warning = 30;
        critical = 15;
      };

      events = {
        on-discharging-warning = "notify-send -u normal 'Low Battery'";
        on-discharging-critical = "notify-send -u critical 'Very Low Battery'";
        on-charging-100 = "notify-send -u normal 'Battery Full!'";
      };
    };
  };
}
