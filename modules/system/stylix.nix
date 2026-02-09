{pkgs, ...}: {
  stylix = {
    enable = true;

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 32;
    };

    base16Scheme = {
      base00 = "071726";
      base01 = "0e2438";
      base02 = "163854";
      base03 = "2a5573";
      base04 = "6fa3c9";
      base05 = "b8dcff";
      base06 = "e6f4ff";
      base07 = "f2fbff";

      base08 = "ff4f9a";
      base09 = "ff8cc6";
      base0A = "ffd166";
      base0B = "6fffd2";
      base0C = "4fdfff";
      base0D = "3aa6ff";
      base0E = "b388ff";
      base0F = "ff6fd8";
    };

    image = ../../wallpapers/anime/cybergirl.jpg;
  };
  home-manager.users.dex.config.stylix.targets = {
    kde.enable = false;
    kde.decorations.enable = false;
    gtk.enable = false;
    qt.enable = false;
    rofi.enable = true;
    librewolf.profileNames = ["default"];
  };
}
