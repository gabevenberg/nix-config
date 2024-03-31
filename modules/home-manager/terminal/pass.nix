{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.password-store = {
    enable = true;
  };

  home.packages = with pkgs; [
    ripasso-cursive
  ];
}
