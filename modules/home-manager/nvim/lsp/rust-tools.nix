{
  config,
  pkgs,
  lib,
  ...
}: {
  config =
    lib.mkIf config.home.nvim.enable-lsp
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
