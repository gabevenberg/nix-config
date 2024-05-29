{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.user.nvim.enable {
    programs.nixvim = {
      opts = {
        timeout = true;
        timeoutlen = 300;
      };
      plugins.which-key = {
        enable = true;
      };
    };
  };
}
