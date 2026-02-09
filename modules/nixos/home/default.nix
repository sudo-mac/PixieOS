{
  imports = [
    ../home/desktop/hyprland/config.nix
    ./mimeapps.nix
    ./firefox.nix
    ./discord.nix
    ./vscodium.nix
  ];

  home.sessionVariables = {EDITOR = "nvim";};

  # stylix.targets.kde = {
  #   enable = false;
  #   decorations.enable = false;
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
