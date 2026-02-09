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
        user.name = "PaperMushrooms";
        user.email = "PaperMushrooms@users.noreply.github.com";
        init.defaultBranch = "main";
      };
    };
  };
}
