{pkgs, ...}: {
  programs.yazi = {
    extraPackages = with pkgs; [
      ffmpeg
      poppler-utils
      jq
      fd
      ripgrep
      ripdrag
      fzf
      zoxide
      imagemagick
      p7zip
      resvg
    ];
    enable = true;
  };
  user.theme.targets = {
    yazi = {
      template = ../../modules/home-manager/theme/templates/yazi.toml;
      path = ".config/yazi/flavors/noctalia.yazi/flavor.toml";
    };
    yazi-syntax = {
      template = ../../modules/home-manager/theme/templates/syntax.tmTheme;
      path = ".config/yazi/flavors/noctalia.yazi/tmtheme.xml";
    };
  };
  # optional dependencies for yazi.
  programs = {
    fzf.enable = true;
    ripgrep.enable = true;
    zoxide.enable = true;
  };
}
