{ inputs, config, lib, pkgs, ... }: with lib;

let
  addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
in

{
  options = { alienix.home.firefox.enable = mkEnableOption "Enable and Configure Firefox"; };

  config = mkIf config.alienix.home.firefox.enable {
    # Web Browser Configuration

    # Configure Firefox
    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          name = "default";
          settings = {
            "browser.theme.content-theme" = 1;
            "browser.theme.toolbar-theme" = 1;
            "ui.systemUsesDarkTheme" = 1;
          };

          bookmarks = {
            force = true;
            settings = [
              {
                name = "Gmail";
                tags = [ "Email" ];
                keyword = "gmail";
                url = "https://mail.google.com/";
              }
              {
                name = "Google Drive";
                tags = [ "Cloud" ];
                keyword = "drive";
                url = "https://drive.google.com/";
              }
              {
                name = "Ebay";
                tags = [ "Shopping" ];
                keyword = "drive";
                url = "https://www.ebay.com/";
              }
              {
                name = "ChatGPT";
                tags = [ "Artificial Intelligence" ];
                keyword = "GPT";
                url = "https://chatgpt.com/";
              }
              {
                name = "GitHub";
                tags = [ "Development" ];
                keyword = "Git";
                url = "https://github.com/";
              }
              {
                toolbar = true;
                bookmarks = [
                  {
                    name = "Gmail";
                    tags = [ "Email" ];
                    keyword = "gmail";
                    url = "https://mail.google.com/";
                  }
                  {
                    name = "Google Drive";
                    tags = [ "Cloud" ];
                    keyword = "drive";
                    url = "https://drive.google.com/";
                  }
                  {
                    name = "Ebay";
                    tags = [ "Shopping" ];
                    keyword = "drive";
                    url = "https://www.ebay.com/";
                  }
                  {
                    name = "ChatGPT";
                    tags = [ "Artificial Intelligence" ];
                    keyword = "GPT";
                    url = "https://chatgpt.com/";
                  }
                  {
                    name = "GitHub";
                    tags = [ "Development" ];
                    keyword = "Git";
                    url = "https://github.com/";
                  }
                ];
              }
            ];
          };
          extensions.packages = with addons; [
            user-agent-string-switcher
            adblocker-ultimate
            stylus
          ];
        };
      };
    };
  };
}
