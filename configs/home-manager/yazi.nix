{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.yazi.enable = true;
  # optional dependencies for yazi.
  programs={
    fzf.enable=true;
    ripgrep.enable=true;
    zoxide.enable=true;
  };
  home.packages = with pkgs; [
    ffmpeg
    poppler_utils
    jq
    fd
    imagemagick
    p7zip
  ];
}
