{...}: {
  programs.imv.enable = true;

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
