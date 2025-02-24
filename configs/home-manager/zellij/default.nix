{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
  };
  home.file = {
    ".config/zellij/config.kdl".source = ./config.kdl;
  };
}
