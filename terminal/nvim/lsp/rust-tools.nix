{
  config,
  pkgs,
  lib,
  ...
}: {
  config =
    lib.mkIf config.host.nvim.enable-lsp
    {
      programs.nixvim = {
        plugins.rust-tools = {
          enable = true;
        };
      };
    };
}
