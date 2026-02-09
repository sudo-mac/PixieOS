{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  programs.nixcord = {
    enable = true; # Enable Nixcord (It also installs Discord)
    vesktop.enable = true; # Vesktop -- currently broken, again... [ 01/02/2026 ]
    dorion.enable = false; # Dorion
    quickCss = "some CSS"; # quickCSS file
    config = {
      useQuickCss = true; # use out quickCSS
      themeLinks = [
        # or use an online theme
        "https://raw.githubusercontent.com/link/to/some/theme.css"
      ];
      frameless = true; # Set some Vencord options
      plugins = {};
    };
    dorion = {
      theme = "dark";
      zoom = "1.1";
      blur = "acrylic"; # "none", "blur", or "acrylic"
      sysTray = true;
      openOnStartup = true;
      autoClearCache = true;
      disableHardwareAccel = false;
      rpcServer = true;
      rpcProcessScanner = true;
      pushToTalk = true;
      pushToTalkKeys = ["RControl"];
      desktopNotifications = true;
      unreadBadge = true;
    };
    extraConfig = {
      # Some extra JSON config here
      # ...
    };
  };
}
