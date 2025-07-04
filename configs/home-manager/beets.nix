{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.beets = {
    enable = true;
    mpdIntegration.enableUpdate = true;
    settings = {
      directory = "~/Music";
      library = "~/Music/library.db";
      import = {
        move = true;
        write = true;
      };
      plugins = [
        "badfiles"
        "chroma"
        "deezer"
        "discogs"
        "duplicates"
        "edit"
        "embedart"
        "fetchart"
        "fromfilename"
        "fuzzy"
        "info"
        "lastgenre"
        "mbsync"
        "missing"
        "replaygain"
        "scrub"
        "spotify"
        "thumbnails"
      ];
      replaygain = {
        auto = false;
        backend = "ffmpeg";
      };
      duplicates = {
        tiebreak.items = ["bitrate"];
      };
      asciify_paths = true;
    };
  };
  home.packages = with pkgs; [
    ffmpeg
  ];
}
