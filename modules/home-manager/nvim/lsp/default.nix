{
  config,
  pkgs,
  lib,
  ...
}: {
  options.user.nvim.enable-lsp = lib.mkEnableOption "nvim lsp";

  config =
    lib.mkIf (config.user.nvim.enable-lsp && config.user.nvim.enable)
    {
      user.nvim.enable-completions = true;
      programs.nixvim = {helpers, ...}: {
        plugins.lsp = {
          enable = true;
          servers = {
            basedpyright.enable = true;
            bashls.enable = true;
            clangd.enable = true;
            hls.enable = true;
            hls.installGhc = true;
            jsonls.enable = true;
            lua_ls.enable = true;
            nil_ls.enable = true;
            nil_ls.settings.formatting.command = ["alejandra"];
            nushell.enable = true;
            ruff.enable = true;
            taplo.enable = true;
            texlab.enable = true;
            tinymist.enable = true;
            uiua.enable = true;
            yamlls.enable = true;
            zls.enable = true;
          };
        };
        plugins.cmp.settings.sources = [
          {name = "nvim_lsp";}
        ];
        plugins.which-key.settings.spec = [
          {
            __unkeyed-1 = "<leader>l";
            group = "+lsp";
          }
        ];
        keymaps = [
          {
            action = helpers.mkRaw "vim.lsp.buf.declaration";
            key = "<leader>lc";
            mode = "n";
            options = {
              silent = true;
              desc = "declaration";
            };
          }
          {
            action = helpers.mkRaw "vim.lsp.buf.definition";
            key = "<leader>ld";
            mode = "n";
            options = {
              silent = true;
              desc = "definition";
            };
          }
          {
            action = helpers.mkRaw "vim.lsp.buf.hover";
            key = "<leader>lh";
            mode = "n";
            options = {
              silent = true;
              desc = "hover";
            };
          }
          {
            action = helpers.mkRaw "vim.lsp.buf.implementation";
            key = "<leader>li";
            mode = "n";
            options = {
              silent = true;
              desc = "implementation";
            };
          }
          {
            action = helpers.mkRaw "vim.lsp.buf.signature_help";
            key = "<leader>ls";
            mode = "n";
            options = {
              silent = true;
              desc = "signature_help";
            };
          }
          {
            action = helpers.mkRaw "vim.lsp.buf.add_workspace_folder";
            key = "<leader>lwa";
            mode = "n";
            options = {
              silent = true;
              desc = "add folder";
            };
          }
          {
            action = helpers.mkRaw "vim.lsp.buf.remove_workspace_folder";
            key = "<leader>lwr";
            mode = "n";
            options = {
              silent = true;
              desc = "remove folder";
            };
          }
          {
            action = helpers.mkRaw "vim.lsp.buf.list_workspace_folders";
            key = "<leader>lw";
            mode = "n";
            options = {
              silent = true;
              desc = "workspace";
            };
          }
          {
            action = helpers.mkRaw "vim.lsp.buf.rename";
            key = "<leader>lr";
            mode = "n";
            options = {
              silent = true;
              desc = "rename";
            };
          }
          {
            action = helpers.mkRaw "vim.lsp.buf.code_action";
            key = "<leader>la";
            mode = "n";
            options = {
              silent = true;
              desc = "code action";
            };
          }
          {
            action = helpers.mkRaw "vim.lsp.buf.references";
            key = "<leader>le";
            mode = "n";
            options = {
              silent = true;
              desc = "list references";
            };
          }
          {
            action = helpers.mkRaw "function() vim.lsp.buf.format{async=true} end";
            key = "<leader>lm";
            mode = "n";
            options = {
              silent = true;
              desc = "format buffer";
            };
          }
          {
            action = helpers.mkRaw "vim.diagnostic.open_float";
            key = "<leader>lo";
            mode = "n";
            options = {
              silent = true;
              desc = "open float";
            };
          }
          {
            action = helpers.mkRaw "vim.diagnostic.goto_next";
            key = "]d";
            mode = "n";
            options = {
              silent = true;
              desc = "next diagnostic";
            };
          }
          {
            action = helpers.mkRaw "vim.diagnostic.goto_prev";
            key = "[d";
            mode = "n";
            options = {
              silent = true;
              desc = "prev diagnostic";
            };
          }
        ];
      };
      home.packages = with pkgs; [
        alejandra
      ];
    };
  imports = [
    ./rustaceanvim.nix
    ./clangd.nix
  ];
}
