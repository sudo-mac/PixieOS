{
  imports = [
    ../home/desktop/hyprland/config.nix
    ./discord.nix
    ./vscodium.nix
  ];

  programs.home-manager.enable = true;
}
