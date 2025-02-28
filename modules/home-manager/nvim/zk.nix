{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.user.nvim.enable {
    programs.nixvim = {
      plugins.zk = {
        enable = true;
        settings.picker = "telescope";
      };
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
        {
          action = ":ZkNotes<CR>";
          key = "<leader>zn";
          mode = "n";
          options = {
            silent = true;
            desc = "Search zk notes";
          };
        }
        {
          action = ":ZkLinks<CR>";
          key = "<leader>zl";
          mode = "n";
          options = {
            silent = true;
            desc = "Search outgoing links";
          };
        }
        {
          action = ":ZkBacklinks<CR>";
          key = "<leader>zb";
          mode = "n";
          options = {
            silent = true;
            desc = "Search incoming links";
          };
        }
        {
          action = ":ZkTags<CR>";
          key = "<leader>zt";
          mode = "n";
          options = {
            silent = true;
            desc = "Search tags";
          };
        }
      ];
    };
  };
}
