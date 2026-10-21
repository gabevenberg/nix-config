{
  config,
  pkgs,
  ...
}: {
  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      color_theme =
        if config.user.theme.noctalia
        then "noctalia"
        else "gruvbox_dark";
    };
  };

  user.theme.targets.btop = {
    template = "${pkgs.noctalia}/share/noctalia/assets/templates/btop/btop.theme";
    path = ".config/btop/themes/noctalia.theme";
    reload = "pkill -USR2 -x btop || true";
  };
}
