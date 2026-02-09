{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./ui.nix
    ./lsp.nix
    ./keymaps.nix
    ./telescope.nix
    ./treesitter.nix
    ./clipboard.nix
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;

        options = {
          # Visuals
          number = true;

          # Indentation
          smartindent = true;
          breakindent = true;

          # Tab Settings
          shiftwidth = 4;
          tabstop = 4;
          expandtab = true;
        };

        utility = {
          multicursors.enable = true;
          yazi-nvim.enable = true;
        };

        debugger.nvim-dap = {
          enable = true;
          ui.enable = true;
        };

        comments.comment-nvim.enable = true;
        statusline.lualine.enable = true;
        dashboard.dashboard-nvim.enable = true;
        autocomplete.blink-cmp.enable = true;

        filetree.neo-tree.enable = true;

        visuals.cinnamon-nvim.enable = true;
      };
    };
  };
}
