{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    host.nvim.enable-treesitter = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        enable nvim treesitter
      '';
    };
  };
  config =
    lib.mkIf config.host.nvim.enable-treesitter
    {
      host.nvim.enable-completions = true;
      programs.nixvim = {
        plugins.treesitter = {
          enable = true;
          folding = true;
          indent = true;
          nixvimInjections = true;
        };
        plugins.treesitter-context.enable = true;
        plugins.indent-blankline.enable = true;
        extraPlugins = with pkgs.vimPlugins; [
          treesj
        ];
        extraConfigLua = ''require("treesj").setup({})'';
      };
    };
  imports = [
    ./rainbow-delimiters.nix
    ./arial.nix
  ];
}
