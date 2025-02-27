{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.user.nvim.enable {
    programs.nixvim = {
      plugins.zk.enable = true;
      plugins.which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>z";
          group = "+zk";
        }
      ];
      keymaps = [
        {
          action = ":ZkNewFromTitleSelection<CR>";
          key = "<leader>zn";
          mode = "v";
          options = {
            silent = true;
            desc = "New zk note with title from selection";
          };
        }
        {
          action = ":ZkaMatch<CR>";
          key = "<leader>zs";
          mode = "v";
          options = {
            silent = true;
            desc = "Search zk notes from selection";
          };
        }
      ];
    };
  };
}
