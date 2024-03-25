{
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

  targets.genericLinux.enable = true;
  home.username = "gabe";
  home.homeDirectory = "/home/gabe";
  imports = [
    ../modules/home-manager/terminal/terminal.nix
    ../modules/home-manager/home-manager.nix
  ];
}
