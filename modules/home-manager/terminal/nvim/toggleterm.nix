{
  configs,
  pkgs,
  ...
}: {
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;
      direction = "horizontal";
      insertMappings = false;
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
}
