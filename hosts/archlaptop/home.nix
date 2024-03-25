{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # machine specific options
  host.enable-speech = true;
  host.nvim.enable-lsp = true;
  host.nvim.enable-treesitter = true;

  home.username = "gabe";
  home.homeDirectory = "/home/gabe";
  imports = [
    ../../modules/home-manager/terminal/terminal.nix
    ../../modules/home-manager/home-manager.nix
    ../../modules/home-manager/kittty/kitty.nix
    inputs.nixvim.homeManagerModules.nixvim
  ];
}
