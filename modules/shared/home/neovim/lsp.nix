{
  pkgs,
  lib,
  ...
}:
{
  programs.nvf.settings.vim = {
    # nvf passes nixfmt `--indent=<shiftwidth>`, and shiftwidth is 4 (see
    # default.nix), which gave 4-space Nix files. Pass nothing, so nixfmt always
    # uses the official 2-space style, the same as `nix fmt`.
    formatter.conform-nvim.setupOpts.formatters.nixfmt.args = lib.mkForce [ ];

    # Type Nix with 2 spaces too, so the code matches what the formatter writes.
    autocmds = [
      {
        event = [ "FileType" ];
        pattern = [ "nix" ];
        command = "setlocal shiftwidth=2 tabstop=2 softtabstop=2";
        desc = "Nix files: 2-space indent (official nixfmt style)";
      }
    ];

    lsp = {
      enable = true;
      presets.harper.enable = true;
      formatOnSave = true;
      otter-nvim.enable = true;
    };

    languages = {
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
        lsp.servers = [ "nixd" ];
        treesitter.enable = true;
        format.enable = true;
        # nixfmt = the official Nix formatter (RFC 166 style, used in nixpkgs).
        format.type = [ "nixfmt" ];
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

      typescript = {
        enable = true;
        lsp.enable = true;
        treesitter.enable = true;
        format.enable = true;
      };

      markdown = {
        enable = true;
        lsp.enable = true;
        treesitter.enable = true;
        format.enable = true;
      };

      openscad = {
        enable = true;
        lsp.enable = true;
      };
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      csharp = {
        enable = true;
        lsp.enable = true;
        treesitter.enable = true;
      };
    };
  };
}
