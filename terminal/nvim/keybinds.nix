{
  configs,
  pkgs,
  ...
}: {
  programs.nixvim = {
    globals = {
      mapleader = ";";
    };
    plugins.which-key.registrations = {
      "<leader>c" = "+check";
    };
    keymaps = [
      {
        action = ":setlocal spell!<CR>";
        key = "<leader>cs";
        mode = "n";
        options = {
          silent = true;
          desc = "toggle spell check";
        };
      }
      {
        action = ":bnext<CR>";
        key = "gf";
        mode = "n";
        options = {
          silent = true;
          desc = "next buffer";
        };
      }
      {
        action = ":bprevious<CR>";
        key = "gF";
        mode = "n";
        options = {
          silent = true;
          desc = "prev buffer";
        };
      }
      {
        action = "<C-w>h";
        key = "<C-h>";
        mode = "n";
        options = {
          silent = true;
          desc = "move to right split";
        };
      }
      {
        action = "<C-w>j";
        key = "<C-j>";
        mode = "n";
        options = {
          silent = true;
          desc = "move to below split";
        };
      }
      {
        action = "<C-w>k";
        key = "<C-k>";
        mode = "n";
        options = {
          silent = true;
          desc = "move to above split";
        };
      }
      {
        action = "<C-w>l";
        key = "<C-l>";
        mode = "n";
        options = {
          silent = true;
          desc = "move to left split";
        };
      }
      {
        action = "za";
        key = "<Space>";
        mode = "n";
        options = {
          silent = true;
          desc = "toggle fold";
        };
      }
      {
        action = ":nohls<CR>";
        key = "<leader>h";
        mode = "n";
        options = {
          silent = true;
          desc = "clear highlighting";
        };
      }
    ];
  };
}
