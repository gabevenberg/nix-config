{
  config,
  pkgs,
  lib,
  ...
}: {
  config =
    lib.mkIf config.home.nvim.enable-treesitter
    {
      programs.nixvim = {
        keymaps = [
          {
            action = ":AerialToggle!<CR>";
            key = "<leader>o";
            mode = "n";
            options = {
              silent = true;
              desc = "toggle outline";
            };
          }
        ];
        extraPlugins = with pkgs.vimPlugins; [
          aerial-nvim
        ];
        extraConfigLua = ''require("aerial").setup({})'';
      };
    };
}
