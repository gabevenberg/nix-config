{
  configs,
  pkgs,
  ...
}: {
  programs.nixvim = {
    plugins.gitsigns = {
      enable = true;
    };
    plugins.which-key.registrations = {
      "<leader>g" = "+git";
    };
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
}
