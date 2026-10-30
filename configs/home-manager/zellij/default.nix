{lib, ...}: {
  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
    settings.theme = lib.mkDefault "gruvbox-dark";
    extraConfig = builtins.readFile ./config.kdl;
  };

  user.theme.targets.zellij = {
    template = ../../../modules/home-manager/theme/templates/zellij.kdl;
    path = ".config/zellij/themes/noctalia.kdl";
  };
}
