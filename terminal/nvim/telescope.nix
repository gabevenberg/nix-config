{
  configs,
  pkgs,
  ...
}: {
  programs.nixvim = {
    plugins.telescope = {
      enable = true;
    };
    plugins.which-key.registrations = {
      "<leader>f" = "+telescope";
      "<leader>fg" = "+telescope git";
    };
    keymaps = [
      {
        action = ":Telescope find_files<CR>";
        key = "<leader>ff";
        mode = "n";
        options = {
          silent = true;
          desc = "files";
        };
      }
      {
        action = ":Telescope live_grep<CR>";
        key = "<leader>fg";
        mode = "n";
        options = {
          silent = true;
          desc = "grep";
        };
      }
      {
        action = ":Telescope buffers<CR>";
        key = "<leader>fb";
        mode = "n";
        options = {
          silent = true;
          desc = "buffers";
        };
      }
      {
        action = ":Telescope marks<CR>";
        key = "<leader>fm";
        mode = "n";
        options = {
          silent = true;
          desc = "marks";
        };
      }
      {
        action = ":Telescope registers<CR>";
        key = "<leader>fr";
        mode = "n";
        options = {
          silent = true;
          desc = "registers";
        };
      }
      {
        action = ":Telescope keymaps<CR>";
        key = "<leader>fk";
        mode = "n";
        options = {
          silent = true;
          desc = "keymaps";
        };
      }
      {
        action = ":Telescope current_buffer_fuzzy_find<CR>";
        key = "<leader>fz";
        mode = "n";
        options = {
          silent = true;
          desc = "fuzzy find";
        };
      }
      {
        action = ":Telescope git_commits<CR>";
        key = "<leader>fgc";
        mode = "n";
        options = {
          silent = true;
          desc = "commits";
        };
      }
      {
        action = ":Telescope git_branches<CR>";
        key = "<leader>fgb";
        mode = "n";
        options = {
          silent = true;
          desc = "branches";
        };
      }
      {
        action = ":Telescope git_stash<CR>";
        key = "<leader>fgs";
        mode = "n";
        options = {
          silent = true;
          desc = "stash";
        };
      }
      {
        action = ":Telescope git_commits<CR>";
        key = "<leader>fgc";
        mode = "n";
        options = {
          silent = true;
          desc = "commits";
        };
      }
    ];
  };
}
