{
  programs.waybar.settings.mainBar."hyprland/workspaces" = {
    format = "{name}";

    # Every bar draws the same list of workspaces, and the theme's stylesheet
    # marks which of them the bar's own monitor is showing (`.hosting-monitor`).
    #
    # With this off -- the default -- each bar builds a list out of its own
    # monitor's workspaces plus its own slice of the persistent set, and the two
    # bars end up disagreeing about what a workspace is called: see the note on
    # `persistent-workspaces` below.
    all-outputs = true;

    # Five slots that are always drawn, by name, on every output.
    #
    # This used to be `"*" = 5`. The integer form does not mean "five workspaces
    # on each monitor" -- waybar numbers each monitor's slice as
    # `(monitorId * amount) + i + 1`, so the laptop got 1..5 and the external
    # display got 6..10, while keybindings.lua kept binding SUPER+1..0 to the
    # single global set 1..10. The second bar was labelled for a set of
    # workspaces that nothing could ever focus.
    #
    # The key/value form has no such offset: a key whose value is an empty list
    # is created under its own name on every monitor.
    persistent-workspaces = {
      "1" = [ ];
      "2" = [ ];
      "3" = [ ];
      "4" = [ ];
      "5" = [ ];
    };

    # Numeric, so the six-to-ten a `SUPER+ALT+<n>` throws a window onto lands
    # after 5 rather than wherever the IPC happened to report it.
    sort-by = "number";

    # The scratchpad (SUPER+S) is an overlay, not a sixth workspace, so it stays
    # out of the switcher.
    show-special = false;
  };
}
