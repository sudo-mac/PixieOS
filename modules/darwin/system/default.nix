{ pkgs, ... }:

{
  imports = [
    ./dock.nix
  ];

  system.defaults = {

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleIconAppearanceTheme = "RegularDark";
    };

    finder = {
      NewWindowTarget = "Home";
      ShowPathbar = true;
      QuitMenuItem = true;
    };

    controlcenter.BatteryShowPercentage = true;

  };

  environment.systemPackages = with pkgs; [
    wget
  ];

  homebrew.casks = [
    "discord"
    "rustdesk"
    "calibre"
    "freecad"
    "orcaslicer"
  ];
}
