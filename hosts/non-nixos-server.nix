{
  config,
  pkgs,
  lib,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # machine specific options
  host.enable-speech = false;
  host.nvim.enable-lsp = false;
  host.nvim.enable-treesitter = true;

  targets.genericLinux.enable = true;
  home.username = "gabe";
  home.homeDirectory = "/home/gabe";
  imports = [
    ../terminal/terminal.nix
  ];
}
