{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.user.nvim.enable {
    programs.nixvim = {
      plugins.gitsigns = {
        enable = true;
      };
      plugins.which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>g";
          group = "+git";
        }
      ];
      keymaps = [
        {
          action = ":Gitsigns toggle_current_line_blame<CR>";
          key = "<leader>gb";
          mode = "n";
          options = {
            silent = true;
            desc = "toggle git blame";
          };
        }
      ];
    };
  };
}
