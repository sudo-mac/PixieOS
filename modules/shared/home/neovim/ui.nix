{
  programs.nvf.settings.vim = {
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

    # Breadcrumbs moved under the statusline's lualine integrations upstream;
    # they are the same nvim-navic / navbuddy pair as before.
    statusline.lualine.integrations.breadcrumbs = {
      nvim-navic.enable = true;
      navbuddy.enable = true;
    };
  };
}
