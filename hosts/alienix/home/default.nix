{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./home-options.nix
    ../../../modules/home
  ];

  home.username = "dex";
  home.homeDirectory = "/home/dex";
  home.stateVersion = "25.11";
}
