{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    fira-code
    # monocraft
    # miracode
    nerd-fonts.symbols-only
  ];

  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "Fira Code";
      theme = "Gruvbox Dark";
      font-size = 12;
      window-decoration = "server";
      window-inherit-working-directory = false;
    };
  };
}
