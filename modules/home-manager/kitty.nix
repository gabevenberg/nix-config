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
    theme = "Gruvbox Dark";
    settings={
      background_opacity="0.8";
    };
  };
}
