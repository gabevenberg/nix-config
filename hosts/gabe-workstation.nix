{
  config,
  pkgs,
  lib,
  ...
}: {
  host = {
    # machine specific options
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
      workProfile = {
        enable = true;
        email = "venberggabe@johndeere.com";
      };
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
