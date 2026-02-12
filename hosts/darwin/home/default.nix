{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./home-options.nix
  ];

  home.username = "matthew";
  home.homeDirectory = "/Users/matthew";
  home.stateVersion = "25.11";

  home.file = {};

  home.sessionVariables = {EDITOR = "nvim";};

  # User Defined Aliases
  programs.zsh = {
    enable = true;
    shellAliases = {
    };
  };

  home.packages = with pkgs; [
  ];

  nixpkgs.config = {allowUnfree = true;};

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
