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

    controlcenter.BatteryShowPercentage = true;
  };
}
