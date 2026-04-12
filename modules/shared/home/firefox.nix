{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {alienix.home.firefox.enable = mkEnableOption "Enable and Configure Firefox";};

  config = mkMerge [
    (mkIf config.alienix.home.firefox.enable {
      programs.librewolf = {
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
                  tags = ["Email"];
                  keyword = "gmail";
                  url = "https://mail.google.com/";
                }
                {
                  name = "Google Drive";
                  tags = ["Cloud"];
                  keyword = "drive";
                  url = "https://drive.google.com/";
                }
                {
                  name = "Ebay";
                  tags = ["Shopping"];
                  keyword = "drive";
                  url = "https://www.ebay.com/";
                }
                {
                  name = "Claude";
                  tags = ["Artificial Intelligence"];
                  keyword = "GPT";
                  url = "https://claude.ai/";
                }
                {
                  name = "GitHub";
                  tags = ["Development"];
                  keyword = "Git";
                  url = "https://github.com/";
                }
                {
                  toolbar = true;
                  bookmarks = [
                    {
                      name = "Gmail";
                      tags = ["Email"];
                      keyword = "gmail";
                      url = "https://mail.google.com/";
                    }
                    {
                      name = "Google Drive";
                      tags = ["Cloud"];
                      keyword = "drive";
                      url = "https://drive.google.com/";
                    }
                    {
                      name = "Ebay";
                      tags = ["Shopping"];
                      keyword = "drive";
                      url = "https://www.ebay.com/";
                    }
                    {
                      name = "Claude";
                      tags = ["Artificial Intelligence"];
                      keyword = "GPT";
                      url = "https://claude.ai/";
                    }
                    {
                      name = "GitHub";
                      tags = ["Development"];
                      keyword = "Git";
                      url = "https://github.com/";
                    }
                  ];
                }
              ];
            };
          };
        };
      };
    })

    (mkIf (config.alienix.home.firefox.enable && pkgs.stdenv.isLinux) {
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = ["firefox.desktop"];
          "application/xhtml+xml" = ["firefox.desktop"];
          "application/x-www-browser" = ["firefox.desktop"];
          "x-scheme-handler/http" = ["firefox.desktop"];
          "x-scheme-handler/https" = ["firefox.desktop"];
          "x-scheme-handler/about" = ["firefox.desktop"];
          "x-scheme-handler/unknown" = ["firefox.desktop"];
        };
      };
    })
  ];
}
