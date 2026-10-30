{
  lib,
  pkgs,
  ...
}: {
  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      color_theme = lib.mkDefault "gruvbox_dark";
    };
  };

  user.theme.targets.btop = {
    template = "${pkgs.noctalia}/share/noctalia/assets/templates/btop/btop.theme";
    path = ".config/btop/themes/noctalia.theme";
    reload = "pkill -USR2 -x btop || true";
  };
}
