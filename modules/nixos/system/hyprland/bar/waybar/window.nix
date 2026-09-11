{
  programs.waybar.settings.mainBar."hyprland/window" = {
    format = "{title}";

    # A title is empty on any output whose focused window is elsewhere, and an
    # empty label collapses to nothing -- which is how the left island ended up
    # as a slab of empty navy with a workspace chip floating in it. The first
    # rule gives that state something to say; the second puts a glyph in front
    # of a real title so the two read as the same object.
    #
    # The rules have to be written against the *formatted* output, so `format`
    # stays a bare {title}: with a glyph baked into the format string there is
    # no empty string left for "^$" to match.
    rewrite = {
      "^$" = "󰇄  Desktop";
      "^(.+)$" = "󰖯  $1";
    };

    # The island hugs its content now that the group's width floor is gone, so
    # this is what actually bounds how wide the left group can get. Three of the
    # budget goes to the glyph prefix above.
    max-length = 40;
    separate-outputs = true;
  };
}
