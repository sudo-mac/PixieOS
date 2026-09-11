{
  pkgs,
  lib,
  ...
}: {
  programs.nvf.settings.vim.clipboard = {
    enable = true;
    providers =
      {
        xclip.enable = true;
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        wl-copy.enable = true;
      };
  };
}
