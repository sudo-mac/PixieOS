{ config, pkgs, ... }:
let
  theme = config.alienix.theme.active;
in

{
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
        dashboard.dashboard-nvim = {
          enable = true;
          setupOpts.config.header = [
            ""
            ""
            "..█.. █.... █████ █████ █...█ █████ █...█"
            ".█.█. █.... ..█.. █.... ██..█ ..█.. .█.█."
            "█...█ █.... ..█.. ████. █.█.█ ..█.. ..█.."
            "█████ █.... ..█.. █.... █..██ ..█.. .█.█."
            "█...█ █████ █████ █████ █...█ █████ █...█"
            ""
            ""
          ];
        };
        autocomplete.blink-cmp.enable = true;

        filetree.neo-tree.enable = true;

        visuals.cinnamon-nvim.enable = true;

        luaConfigPost = ''
          vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "${theme.c.accentHex "info"}", bold = true })
        '';
      };
    };
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    live-server
  ];
}
