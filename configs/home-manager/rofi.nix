{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.rofi = {
    enable = true;
    location = "top";
    terminal = "kitty";
    theme = "gruvbox-dark-soft";
  };
}
