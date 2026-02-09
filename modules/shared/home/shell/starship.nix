{
  lib,
  pkgs,
  ...
}: {
  programs.starship =
    {
      settings = {
        add_newline = true;
        command_timeout = 1300;
        scan_timeout = 50;

        format = ''
          $username@$hostname $directory$git_branch$git_state$git_status
          $character
        '';

        username.show_always = true;

        hostname = {
          ssh_only = false;
          format = "[$ssh_symbol](bold green)[$hostname](bold green) ";
          trim_at = ".";
          disabled = false;
        };

        character = {
          success_symbol = "[➜](bold green) ";
          error_symbol = "[✗](bold red) ";
        };
      };
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      enable = true;
    };
}
