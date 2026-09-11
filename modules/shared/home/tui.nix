{...}: {
  # These three were declared at the system level, where stylix cannot reach
  # them -- its btop, yazi and tmux targets all write home-manager options, so
  # a NixOS-level `programs.btop.enable` left the target inert and the program
  # in its stock colours. Declaring them here is what themes them.
  programs = {
    btop.enable = true;

    yazi.enable = true;

    tmux = {
      enable = true;
      extraConfig = ''
        set -g mouse on
      '';
    };
  };
}
