{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    host.nvim.enable-lsp = lib.mkEnableOption "nvim lsp";
  };

  config =
    lib.mkIf config.host.nvim.enable-lsp
    {
      host.nvim.enable-completions = true;
      programs.nixvim = {
        plugins.lsp = {
          enable = true;
          servers = {
            bashls.enable = true;
            clangd.enable = true;
            lua-ls.enable = true;
            nil_ls.enable = true;
            nil_ls.settings.formatting.command = ["alejandra"];
            nushell.enable = true;
            pyright.enable = true;
            ruff-lsp.enable = true;
            rust-analyzer = {
              enable = true;
              installCargo = true;
              installRustc = true;
            };
            texlab.enable = true;
            typst-lsp.enable = true;
            taplo.enable = true;
            yamlls.enable = true;
            marksman.enable = true;
            jsonls.enable = true;
            hls.enable = true;
          };
        };
        plugins.cmp.settings.sources = [
          {name = "nvim_lsp";}
        ];
        plugins.which-key.registrations = {
          "<leader>l" = "+lsp";
        };
        keymaps = [
          {
            action = "vim.lsp.buf.declaration";
            key = "<leader>lc";
            lua = true;
            mode = "n";
            options = {
              silent = true;
              desc = "declaration";
            };
          }
          {
            action = "vim.lsp.buf.definition";
            key = "<leader>ld";
            lua = true;
            mode = "n";
            options = {
              silent = true;
              desc = "definition";
            };
          }
          {
            action = "vim.lsp.buf.hover";
            key = "<leader>lh";
            lua = true;
            mode = "n";
            options = {
              silent = true;
              desc = "hover";
            };
          }
          {
            action = "vim.lsp.buf.implementation";
            key = "<leader>li";
            lua = true;
            mode = "n";
            options = {
              silent = true;
              desc = "implementation";
            };
          }
          {
            action = "vim.lsp.buf.signature_help";
            key = "<leader>ls";
            lua = true;
            mode = "n";
            options = {
              silent = true;
              desc = "signature_help";
            };
          }
          {
            action = "vim.lsp.buf.add_workspace_folder";
            key = "<leader>lwa";
            lua = true;
            mode = "n";
            options = {
              silent = true;
              desc = "add folder";
            };
          }
          {
            action = "vim.lsp.buf.remove_workspace_folder";
            key = "<leader>lwr";
            lua = true;
            mode = "n";
            options = {
              silent = true;
              desc = "remove folder";
            };
          }
          {
            action = "vim.lsp.buf.list_workspace_folders";
            key = "<leader>lw";
            lua = true;
            mode = "n";
            options = {
              silent = true;
              desc = "workspace";
            };
          }
          {
            action = "vim.lsp.buf.rename";
            key = "<leader>lr";
            lua = true;
            mode = "n";
            options = {
              silent = true;
              desc = "rename";
            };
          }
          {
            action = "vim.lsp.buf.code_action";
            key = "<leader>la";
            lua = true;
            mode = "n";
            options = {
              silent = true;
              desc = "code action";
            };
          }
          {
            action = "vim.lsp.buf.references";
            key = "<leader>le";
            lua = true;
            mode = "n";
            options = {
              silent = true;
              desc = "list references";
            };
          }
          {
            action = "function() vim.lsp.buf.format{async=true} end";
            key = "<leader>lm";
            lua = true;
            mode = "n";
            options = {
              silent = true;
              desc = "format buffer";
            };
          }
          {
            action = "vim.diagnostic.open_float";
            key = "<leader>lo";
            lua = true;
            mode = "n";
            options = {
              silent = true;
              desc = "open float";
            };
          }
          {
            action = "vim.diagnostic.goto_next";
            key = "]d";
            lua = true;
            mode = "n";
            options = {
              silent = true;
              desc = "next diagnostic";
            };
          }
          {
            action = "vim.diagnostic.goto_prev";
            key = "[d";
            lua = true;
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
    ./rust-tools.nix
    ./clangd.nix
  ];
}
