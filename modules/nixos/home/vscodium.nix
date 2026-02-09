{ config, lib, pkgs, ... }:
with lib; {
  options = { alienix.home.vscodium.enable = mkEnableOption "enables VSCodium"; };

  config = mkIf config.alienix.home.vscodium.enable {
    # Configure VScodium
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles = {
        default = {
          extensions = with pkgs.vscode-extensions; [
            ms-python.python # Python extension
            jnoortheen.nix-ide # Nix language support
            esbenp.prettier-vscode # Prettier for formatting
            ms-vscode.live-server # HTML live live-server
            vscode-icons-team.vscode-icons # language icons for visual improvment
            jackmacwindows.vscode-computercraft
            jackmacwindows.craftos-pc
          ];

          userSettings = {
            craftos-pc.executablePath.linux = "/run/current-system/sw/bin/craftos";
          };
        };
      };
    };
  };
}
