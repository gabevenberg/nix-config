{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf (config.user.nvim.enable-lsp && config.user.nvim.enable) {
    programs.nixvim = {
      plugins.lsp.servers.zls = {
        enable = true;
        settings = {
          enable_build_on_save = true;
        };
      };
    };
  };
}
