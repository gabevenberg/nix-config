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
  # optional dependencies for yazi.
  programs = {
    fzf.enable = true;
    ripgrep.enable = true;
    zoxide.enable = true;
  };
}
