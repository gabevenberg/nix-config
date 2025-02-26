{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.user.nvim.enable {
    programs.nixvim = {
      plugins.zk.enable = true;
    };
    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>z";
        group = "+zk";
      }
    ];
    keymaps = [
      {
        action = ":ZkNewFromTitleSelection";
        key = "<leader>zn";
        mode = "n";
        options = {
          silent = true;
          desc = "New zk note with title from selection";
        };
      }
      {
        action = ":ZkaMatch";
        key = "<leader>zs";
        mode = "n";
        options = {
          silent = true;
          desc = "Search zk notes from selection";
        };
      }
    ];
  };
}
