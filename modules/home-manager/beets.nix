{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.beets = {
    enable = true;
    settings = {
      directory = "~/Music";
      library = "~/Music/library.db";
      import = {
        move = true;
        write = true;
      };
      plugins = [
        "edit"
        "fetchart"
        "chroma"
        "thumbnails"
        "replaygain"
        "mbsync"
        "fuzzy"
        "duplicates"
        "badfiles"
        "fromfilename"
      ];
      replaygain = {
        auto = false;
        backend = "ffmpeg";
      };
      asciify_paths = true;
    };
  };
  home.packages = with pkgs; [
    ffmpeg
  ];
}
