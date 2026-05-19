{
  imports = [
    ./dock.nix
    ./packages.nix
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
}
