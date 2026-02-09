{
  imports = [
    ./options.nix
    ../../../modules/darwin/home
  ];

  home.username = "mac";
  home.homeDirectory = "/Users/mac";
  home.stateVersion = "25.11";
}
