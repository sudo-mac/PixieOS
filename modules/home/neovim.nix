{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        keymaps = [
          {
            mode = "n";
            key = "<leader>e";
            action = "Yazi:<CR>";
            desc = "Open Yazi";
            silent = true;
          }
        ];

        lsp = {
          enable = true;
          formatOnSave = true;
          otter-nvim.enable = true;
          harper-ls.enable = true;
          servers.nixd.settings.nil.nix.autoArchive = false;
        };

        viAlias = true;
        vimAlias = true;

        clipboard = {
          enable = true;
          providers = {
            xclip.enable = true;
            wl-copy.enable = true;
          };
        };

        comments.comment-nvim.enable = true;
        statusline.lualine.enable = true;
        dashboard.dashboard-nvim.enable = true;
        autocomplete.blink-cmp.enable = true;

        filetree.neo-tree.enable = true;

        ui = {
          noice.enable = true;
          illuminate.enable = true;
          nvim-highlight-colors.enable = true;
          colorful-menu-nvim.enable = true; ## OR colorizor.enable = true;
          breadcrumbs.enable = true;
          breadcrumbs.navbuddy.enable = true;
          borders = {
            enable = true;
            globalStyle = "rounded";
          };
        };

        telescope = {
          enable = true;
          extensions = [
            {
              name = "fzf";
              packages = [pkgs.vimPlugins.telescope-fzf-native-nvim];
              setup = {fzf = {fuzzy = true;};};
            }
          ];
        };

        debugger.nvim-dap = {
          enable = true;
          ui.enable = true;
        };

        languages = {
          enableTreesitter = true;
          enableFormat = true;

          nix = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
            format.enable = true;
          };

          python = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
            format.enable = true;
          };

          lua = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
            format.enable = true;
          };

          html = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
            format.enable = true;
          };

          css = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
            format.enable = true;
          };

          ts = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
            format.enable = true;
          };
        };

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

        treesitter = {
          enable = true;
          autotagHtml = true;
          context.enable = true;
        };

        utility = {
          multicursors.enable = true;
          yazi-nvim.enable = true;
        };
        visuals.cinnamon-nvim.enable = true;
      };
    };
  };
  stylix.targets.nvf.enable = true;
}
