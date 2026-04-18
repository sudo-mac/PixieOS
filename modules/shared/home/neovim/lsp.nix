{
  pkgs,
  lib,
  ...
}: {
  programs.nvf.settings.vim = {
    lsp = {
      enable = true;
      presets.harper.enable = true;
      formatOnSave = true;
      otter-nvim.enable = true;
    };

    languages =
      {
        enableTreesitter = true;
        enableFormat = true;

        bash = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
          format.enable = true;
        };

        nix = {
          enable = true;
          lsp.enable = true;
          lsp.servers = ["nixd"];
          treesitter.enable = true;
          format.enable = true;
          format.type = ["nixfmt"];
        };

        clang = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
          cHeader = true;
          dap.enable = true;
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
      }
      // lib.optionalAttrs pkgs.stdenv.isLinux {
        csharp = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
      };
  };
}
