{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    host.nvim.enable-completions =
      (lib.mkEnableOption "basic completion in nvim")
      // {
        default = config.host.nvim.enable-treesitter || config.host.nvim.enable-lsp;
      };
  };
  config =
    lib.mkIf config.host.nvim.enable-completions
    {
      programs.nixvim = {
        plugins.luasnip.enable = true;
        plugins.friendly-snippets.enable = true;
        plugins.cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            sources = [
              {name = "luasnip";}
              {name = "treesitter";}
              {name = "path";}
              {name = "emoji";}
              {name = "buffer";}
              {name = "latex_symbols";}
              {name = "digraphs";}
              {name = "spell";}
            ];
            snippet = {
              expand = "function(args) require('luasnip').lsp_expand(args.body) end";
            };
            mapping = {
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-d>" = "cmp.mapping.scroll_docs(-4)";
              "<C-e>" = "cmp.mapping.close()";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<CR>" = "cmp.mapping.confirm({ select = false })";
              "<Tab>" = ''
                function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif require("luasnip").expand_or_jumpable() then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
                  else
                    fallback()
                  end
                end
              '';
              "<S-Tab>" = ''
                function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif require("luasnip").jumpable(-1) then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
                  else
                    fallback()
                  end
                end
              '';
            };
          };
        };
      };
    };
}
