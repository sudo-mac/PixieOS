{ config, ... }:
{
  # stylix's nvf target writes `vim.statusline.lualine.theme`, which nvf renamed
  # to `...lualine.setupOpts.options.theme` -- so every evaluation carried a
  # deprecation warning. The target's whole job is the base16 colorscheme plus
  # that one lualine line, both of which are set below against the current
  # option paths. Same reasoning as the regreet, hyprlock and dunst targets.
  stylix.targets.nvf.enable = false;

  programs.nvf.settings.vim = {
    # The palette still comes from stylix (and so from modules/themes) -- only
    # the writing of it moved here.
    theme = {
      enable = true;
      name = "base16";
      base16-colors = {
        inherit (config.lib.stylix.colors.withHashtag)
          base00
          base01
          base02
          base03
          base04
          base05
          base06
          base07
          base08
          base09
          base0A
          base0B
          base0C
          base0D
          base0E
          base0F
          ;
      };
    };

    ui = {
      noice.enable = true;
      illuminate.enable = true;
      nvim-highlight-colors.enable = true;
      colorful-menu-nvim.enable = true;
      borders = {
        enable = true;
        globalStyle = "rounded";
      };
    };

    statusline.lualine = {
      setupOpts.options.theme = "base16";

      # Breadcrumbs moved under the statusline's lualine integrations upstream;
      # they are the same nvim-navic / navbuddy pair as before.
      integrations.breadcrumbs = {
        nvim-navic.enable = true;
        navbuddy.enable = true;
      };
    };
  };
}
