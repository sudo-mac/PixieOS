{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  colors = config.lib.stylix.colors;

  # stylix's bat theme colours Nix attribute names (`programs`, `enable`, ...)
  # with base09, where Neovim draws them in the plain text colour (base05).
  # Build the same theme from stylix's own template, then add one rule at the
  # end (later rules win) so they match Neovim. Follows the active palette.
  stylixBatTheme = colors {
    # The template's text: a plain string is read as the template itself.
    template = builtins.readFile "${inputs.stylix}/modules/bat/base16-stylix.tmTheme.mustache";
    extension = ".tmTheme";
  };
  nixAttrRule = lib.concatStrings [
    "<dict><key>name</key><string>Nix attribute names (text colour, like Neovim)</string>"
    "<key>scope</key><string>source.nix entity.other.attribute-name</string>"
    "<key>settings</key><dict><key>foreground</key><string>${colors.withHashtag.base05}</string></dict></dict>"
  ];
  batTheme = pkgs.runCommand "base16-stylix.tmTheme" { } ''
    # Insert the rule before the last </array> (the end of the theme's rules).
    awk -v rule='${nixAttrRule}' '
      { line[NR] = $0 } /<\/array>/ { last = NR }
      END { for (i = 1; i <= NR; i++) { if (i == last) print rule; print line[i] } }
    ' ${stylixBatTheme} > $out
    grep -q 'Nix attribute names' $out
  '';
in
{
  # These were declared at the system level, where stylix cannot reach
  # them -- its btop, yazi and tmux targets all write home-manager options, so
  # a NixOS-level `programs.btop.enable` left the target inert and the program
  # in its stock colours. Declaring them here is what themes them.
  programs = {
    btop.enable = true;

    # bat too: stylix's bat target gives it a "base16-stylix" theme from the
    # active palette, the same colours Neovim's base16 theme uses. Its theme
    # file is swapped for the one above (same theme + the Nix attribute rule).
    bat = {
      enable = true;
      themes."base16-stylix".src = lib.mkForce batTheme;
    };

    yazi.enable = true;

    tmux = {
      enable = true;
      extraConfig = ''
        set -g mouse on
      '';
    };
  };
}
