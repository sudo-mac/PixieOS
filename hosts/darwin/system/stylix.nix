{ pkgs, ... }: {
  stylix = {
    enable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/hardhacker.yaml";

    image = ../../../wallpapers/alienix/aliens-chill.png;
  };
}
