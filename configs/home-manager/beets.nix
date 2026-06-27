{pkgs, ...}: {
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
        "musicbrainz"
        "replaygain"
        "scrub"
        "spotify"
        "thumbnails"
        "zero"
      ];
      replaygain = {
        auto = false;
        backend = "ffmpeg";
      };
      duplicates = {
        tiebreak.items = ["bitrate"];
      };
      zero = {
        keep_fields = [
          "title"
          "album"
          "albumartist"
          "albumartists"
          "artist"
          "artists"
          "bitdepth"
          "bitrate"
          "bpm"
          "disc"
          "disctotal"
          "id"
          "lyrics"
          "month"
          "day"
          "year"
          "track"
          "images"
        ];
        update_database = true;
        omit_single_disc = true;
      };
      asciify_paths = true;
    };
  };
  home.packages = with pkgs; [
    ffmpeg
  ];
}
