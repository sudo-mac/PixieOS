{
  config,
  lib,
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

    # Hand off to zsh only for real interactive terminal sessions.
    #
    # The interactivity guard is load-bearing. A non-interactive login shell --
    # bash -lc "...", which is what editors, tooling and agents use -- also
    # sources this file, and exec replaces the process image before the -c
    # command is ever run. The command is destroyed along with the process, and
    # the interactive zsh left in its place then blocks forever on stdin that
    # never delivers. Every such command hangs with no output and no error.
    #
    # Non-interactive shells have no "i" in $-, so they return early here.
    home.file.".bash_profile".text = ''
      case $- in
        *i*) ;;
        *) return ;;
      esac

      if [ -t 0 ] && { [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; }; then
        exec zsh
      fi
    '';
  };
}
