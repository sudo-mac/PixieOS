{ config, lib, pkgs, ... }:
with lib; {
  options = { alienix.system.libreoffice.enable = mkEnableOption "Enable LibreOffice"; };

  config = mkIf config.alienix.system.libreoffice.enable {
    environment.systemPackages = with pkgs; [ libreoffice-qt hunspell ];
  };
}
