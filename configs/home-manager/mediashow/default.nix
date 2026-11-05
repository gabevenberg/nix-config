{...}: {
  programs.nushell.extraConfig = ''
    def mediashow [delay: int = 10, dir: path = "."] {
        ^mpv --fs --shuffle --loop-playlist=inf --script=${./mediashow.lua} --directory-filter-types=video,image --image-display-duration=$delay $dir
    }
  '';
  programs.zsh.initContent = ''
    mediashow() {
        mpv --fs --shuffle --loop-playlist=inf --script=${./mediashow.lua} --directory-filter-types=video,image --image-display-duration="''${1:-10}" "''${2:-.}"
    }
  '';
}
