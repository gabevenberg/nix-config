{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.user.nvim.enable {
    programs.nixvim = {
      plugins.toggleterm = {
        enable = true;
        settings = {
          direction = "horizontal";
          insert_mappings = false;
          terminal_mappings = false;
          open_mapping = ''[[<c-\>]]'';
        };
      };
      keymaps = [
        {
          action = "function() Floatingterm:toggle() end";
          key = "<leader>s";
          lua = true;
          mode = "n";
          options = {
            silent = true;
            desc = "toggle scratch terminal";
          };
        }
      ];
      extraConfigLuaPre = ''
        local Terminal = require('toggleterm.terminal').Terminal
        Floatingterm = Terminal:new({
            hidden = true,
            direction = "float"
        })
      '';
    };
  };
}
