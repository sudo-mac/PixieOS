{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bitwarden-cli # `bw` command-line client
    bitwarden-desktop # GUI app
    bitwarden-menu # dmenu/rofi/wofi/fuzzel picker for the vault
  ];
}
