{
  config,
  pkgs,
  lib,
  ...
}: {
  config =
    lib.mkIf (config.user.nvim.enable-lsp && config.user.nvim.enable)
    {
      programs.nixvim = {
        plugins.rustaceanvim = {
          enable = true;
        };
      };
    };
}
