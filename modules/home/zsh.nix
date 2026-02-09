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
          pxie = "cd /etc/nixos/ && git pull";
          update = "nix flake update --flake .";
          switch = "nh os test .";
          build = "nh os build .";
          cleanup = "nix-collect-garbage --delete-older-than 15d";
          cleanup-full = "sudo nix-collect-garbage --delete-older-than 15d";
          mkrecovery = "nix build .#nixosConfigurations.recovery.config.system.build.isoImage";
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
