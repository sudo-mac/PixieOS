{
  pkgs,
  lib,
  ...
}: {
  programs.oh-my-posh =
    {
      enableBashIntegration = true;
      enableZshIntegration = true;
      useTheme = "material";
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      enable = true;
    };
}
