{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.rofi = {
    enable = true;
    location = "top";
    terminal = "ghostty";
    theme = "gruvbox-dark-soft";
  };
}
