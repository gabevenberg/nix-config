{
  config,
  pkgs,
  lib,
  ...
}: {
  options.user.nvim.enable-treesitter = lib.mkEnableOption "enable nvim treesitter";

  config =
    lib.mkIf (config.user.nvim.enable-treesitter && config.user.nvim.enable)
    {
      user.nvim.enable-completions = true;
      programs.nixvim = {
        opts.foldmethod = "expr";
        plugins.treesitter = {
          enable = true;
          folding = true;
          settings.indent.enable = true;
          nixvimInjections = true;
        };
        plugins.treesitter-context.enable = true;
        plugins.indent-blankline.enable = true;
        extraPlugins = with pkgs.vimPlugins; [
          treesj
        ];
        extraConfigLua = ''
          require("treesj").setup({
              use_default_keymaps=false,
          })
        '';
        keymaps = [
          {
            action = ":TSContextToggle<CR>";
            key = "<leader>x";
            mode = "n";
            options = {
              silent = true;
              desc = "tree context toggle";
            };
          }
          {
            action = ":TSJToggle<CR>";
            key = "<leader>j";
            mode = "n";
            options = {
              silent = true;
              desc = "tree sitter join toggle";
            };
          }
        ];
      };
    };
  imports = [
    ./rainbow-delimiters.nix
    ./arial.nix
    ./tree-sitter-nu.nix
  ];
}
