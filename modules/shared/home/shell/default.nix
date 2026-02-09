{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    alienix.home.shell.enable = mkEnableOption "Enable and configure my terminal setup";
  };

  imports = [
    ./kitty.nix
    ./aliases.nix
    ./starship.nix
    ./oh-my-posh.nix
  ];

  config = mkIf config.alienix.home.shell.enable {
    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        initContent = ''
          autoload -Uz compinit
          compinit

          # Arrow-key menu completion
          zstyle ':completion:*' menu select

          # Optional improvements
          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
        '';
      };
    };

    fonts.fontconfig.enable = true;

    home.file.".bash_profile".text = ''
      if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
        exec zsh
      fi
    '';

    # Install Terminal Add-on Packages and Fontsv
    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };
}
