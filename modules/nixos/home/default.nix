{
  imports = [
    ../home/desktop/hyprland/config.nix
    ./firefox.nix
    ./discord.nix
    ./vscodium.nix
  ];

  programs.home-manager.enable = true;
}
