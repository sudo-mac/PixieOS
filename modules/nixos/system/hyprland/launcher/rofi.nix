{
  config,
  lib,
  ...
}:
with lib;
let
  theme = config.alienix.theme.active;
  style = theme.style.rofi theme;
in
{
  config = mkIf (theme.components.launcher == "rofi") {
    programs.rofi = {
      enable = true;
      theme = mkForce theme.meta.name;
    };

    xdg.configFile."rofi/${theme.meta.name}.rasi".text = ''
      configuration {
        show-icons: true;
        icon-theme: "${style.iconTheme}";
        display-drun: " ";
        drun-display-format: "{icon}  {name}";
      }

      ${style.rasi}
    '';
  };
}
