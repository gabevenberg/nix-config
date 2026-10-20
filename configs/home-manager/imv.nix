{lib, ...}: {
  programs.imv = {
    enable = true;
    settings.binds."<Ctrl+w>" = ''exec set-wallpaper "$imv_current_file"'';
  };
  # imv.desktop's mimetype
  xdg.mimeApps.defaultApplications = lib.genAttrs [
    "image/x-farbfeld"
    "image/tiff"
    "image/tiff-fx"
    "image/png"
    "image/x-png"
    "image/jpeg"
    "image/jpg"
    "image/pjpeg"
    "image/svg+xml"
    "image/gif"
    "image/bmp"
    "image/x-bmp"
    "image/heif"
    "image/avif"
    "image/jxl"
    "image/webp"
    "image/qoi"
  ] (_: "imv.desktop");

  programs.nushell.extraConfig = ''
    def slideshow [delay: int = 10, dir: path = "."] {
        glob --no-dir $"($dir)/**/\(?i)*.{jpg,jpeg,png,gif,bmp,webp,tif,tiff,svg,jxl,heic,heif,avif,qoi}"
        | shuffle | str join "\n" | ^imv -f -t $delay
    }
  '';
  programs.zsh.initContent = ''
    slideshow() {
        find "''${2:-.}" -type f -regextype posix-extended \
          -iregex '.*\.(jpe?g|png|gif|bmp|webp|tiff?|svg|jxl|hei[cf]|avif|qoi)' \
          | shuf | imv -f -t "''${1:-10}"
    }
  '';
}
