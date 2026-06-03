{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wget
  ];

  homebrew.casks = [
    "discord"
    "rustdesk"
    "calibre"
    "freecad"
  ];
}
