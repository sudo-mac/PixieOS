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

  config = mkIf config.alienix.home.shell.enable {
    # Enable and Configure Zsh
    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        # Zsh Aliases
        shellAliases = {
          update = "nix flake update --flake .";
          cleanup = "nix-collect-garbage -d";
          cleanup-full = "sudo nix-collect-garbage -d";
          mkrecovery = "nix build .#nixosConfigurations.recovery.config.system.build.isoImage";

          SDlab = "nix-shell shells/PoGo-Root";

          format = "nix-shell -p nixpkgs-fmt --run 'nixpkgs-fmt .'";
        };

        initContent = ''
          autoload -Uz compinit
          compinit

          # Arrow-key menu completion
          zstyle ':completion:*' menu select

          # Optional improvements
          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
        '';
      };

      # Enable and Configure Oh-My-Posh Plugin
      oh-my-posh = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        useTheme = "material";
      };
    };

    # Enable Font Configuration for NixOS
    fonts.fontconfig.enable = true;

    #Auto-Start Zsh when logging into a graphical session
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
