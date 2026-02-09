{ config, lib, pkgs, ... }:
with lib; {
  options = {
    gnomesys.enable = mkEnableOption "Enable Gnome desktop environment";
  };

  config = mkIf config.gnomesys.enable {
    # Enable GNOME Desktop Environment.
    services.desktopManager.gnome.enable = true;

    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # System-wide GNOME packages
    environment.systemPackages = with pkgs; [
      gnome-shell
      gnome-control-center
      gnome-tweaks
      gnomeExtensions.desktop-cube
      gnomeExtensions.burn-my-windows
      gnomeExtensions.compiz-windows-effect
    ];

    # Enable dconf
    programs.dconf.enable = true;
  };
}
