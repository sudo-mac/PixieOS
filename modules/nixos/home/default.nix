{
  imports = [
    ./chromium.nix
    ./discord.nix
    ./vscodium.nix
  ];

  programs.home-manager.enable = true;
}
