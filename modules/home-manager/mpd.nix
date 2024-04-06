{
  config,
  pkgs,
  lib,
  ...
}: {
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    network.startWhenNeeded = true;
    playlistDirectory = "${config.services.mpd.musicDirectory}/.mpd/playlists";
    extraConfig = ''
      restore_paused "yes"
      auto_update "yes"
      replaygain "auto"
      follow_outside_symlinks "yes"

      #for ncmpcpp visualizer
      audio_output {
          type "fifo"
          name "Visualizer feed"
          path "/tmp/mpd.fifo"
          format "44100:16:2"
      }
      audio_output {
        type "pipewire"
        name "PipeWire Sound Server"
      }
    '';
  };

  services.mpd-mpris.enable = true;

  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override {visualizerSupport = true;};
    settings = {
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "Visualizer feed";
      visualizer_in_stereo = "yes";
      visualizer_type = "spectrum";
      visualizer_fps = 60;
      visualizer_autoscale = "no";
      visualizer_look = "●▮";
      visualizer_color = "blue, cyan, green, yellow, magenta, red";

      ##
      ## Note: The next few visualization options apply to the spectrum visualizer.
      ##
      visualizer_spectrum_smooth_look = "yes";

      ## A value between 1 and 5 inclusive. Specifying a larger value makes the
      ## visualizer look at a larger slice of time, which results in less jumpy
      ## visualizer output.
      visualizer_spectrum_dft_size = 2;
      visualizer_spectrum_gain = 10;
      visualizer_spectrum_hz_min = 20;
      visualizer_spectrum_hz_max = 20000;
    };
  };

  home.packages = with pkgs; [
    mpc-cli
  ];
}
