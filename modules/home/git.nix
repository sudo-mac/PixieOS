{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {alienix.home.git.enable = mkEnableOption "Enables Git";};

  config = mkIf config.alienix.home.git.enable {
    # Enable and Configure Git
    programs.git = {
      enable = true;
      settings = {
        user.name = "sudo-mac";
        user.email = "sudo-mac@users.noreply.github.com";
        init.defaultBranch = "main";
      };
    };

    home.packages = [
      pkgs.github-desktop
      pkgs.lazygit

      (pkgs.writeShellScriptBin "commit" ''
        read -r -p "Enter commit message: " message

        if [ -z $message ]; then
            echo "Commit message cannot be empty!"
            exit 1
        fi

        git add .
        git commit -m "$message"
        git push -u origin main
      '')
    ];
  };
}
