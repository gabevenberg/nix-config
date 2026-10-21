{config, ...}: {
  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
  };

  home.file.".config/zellij/config.kdl".text = ''
    ${builtins.readFile ./config.kdl}
    theme "${
      if config.user.theme.noctalia
      then "noctalia"
      else "gruvbox-dark"
    }"
  '';

  user.theme.targets.zellij = {
    template = ../../../modules/home-manager/theme/templates/zellij.kdl;
    path = ".config/zellij/themes/noctalia.kdl";
  };
}
