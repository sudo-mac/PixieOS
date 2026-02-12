{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    gimp # Photo Editor
    #   ungoogled-chromium # Web Browser
    telegram-desktop # Private Messenger
    btop # System Monitor
    payload-dumper-go # Payload.bin dumper
    qt6.qttools # Add-ons for GNOME
  ];
}
