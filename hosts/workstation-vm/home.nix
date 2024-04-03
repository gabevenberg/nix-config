{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  # machine specific options
  host = {
    enable-speech = true;
    nvim = {
      enable-lsp = true;
      enable-treesitter = true;
    };
    git = {
      profile = {
        name = "Gabe Venberg";
        email = "gabevenberg@gmail.com";
      };
      workProfile.enable = false;
    };
  };

  imports = [
    ../../modules/home-manager/terminal
    ../../modules/home-manager/nvim
    ../../modules/home-manager
    ../../modules/home-manager/kitty.nix
    inputs.nixvim.homeManagerModules.nixvim
  ];
}
