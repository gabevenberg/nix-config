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
      name = "Fira Code";
    };
    theme = "Gruvbox Dark";
  };
}
