{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../modules/home-manager/terminal
    ../../modules/home-manager/nvim
    ../../modules/home-manager
    ../../modules/home-manager/kitty.nix
    inputs.nixvim.homeManagerModules.nixvim
  ];
}
