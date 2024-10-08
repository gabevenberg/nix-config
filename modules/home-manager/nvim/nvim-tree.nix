{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.user.nvim.enable {
    programs.nixvim = {
      plugins.web-devicons.enable = true;
      plugins.nvim-tree = {
        enable = true;
        disableNetrw = true;
        hijackCursor = true;
        hijackNetrw = true;
        hijackUnnamedBufferWhenOpening = true;
        actions = {
          useSystemClipboard = true;
          changeDir.enable = true;
        };
        filesystemWatchers.enable = true;
      };
      keymaps = [
        {
          action = ":NvimTreeToggle<CR>";
          key = "<leader>t";
          mode = "n";
          options = {
            silent = true;
            desc = "toggle file browser";
          };
        }
      ];
    };
  };
}
