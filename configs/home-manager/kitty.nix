{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.fira-code-nerdfont;
      name = "FiraCode Nerd Font";
    };
    themeFile = "gruvbox-dark";
    settings = {
      background_opacity = "0.8";
    };
  };
}
