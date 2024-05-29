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
        plugins.rust-tools = {
          enable = true;
          server = {
            checkOnSave = true;
            check.command = "clippy";
          };
        };
      };
    };
}
