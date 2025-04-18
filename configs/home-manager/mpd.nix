{
  config,
  pkgs,
  lib,
  ...
}: let
  visualizer = false;
in {
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    network.startWhenNeeded = true;
    playlistDirectory = "${config.services.mpd.musicDirectory}/.mpd/playlists";
    extraConfig =
      ''
        restore_paused "yes"
        auto_update "yes"
        replaygain "auto"
        follow_outside_symlinks "yes"

        audio_output {
          type "pipewire"
          name "PipeWire Sound Server"
        }
      ''
      + lib.optionalString visualizer
      ''
        #for ncmpcpp visualizer
        audio_output {
            type "fifo"
            name "Visualizer feed"
            path "/tmp/mpd.fifo"
            format "44100:16:2"
        }
      '';
  };

  services.mpd-mpris.enable = true;

  programs.ncmpcpp = {
    enable = true;
    package = lib.mkIf visualizer (pkgs.ncmpcpp.override {visualizerSupport = true;});
    settings = lib.mkIf visualizer {
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
    playerctl
    rmpc
  ];

  # rmpc config.
  home.file.".config/rmpc/config.ron".text = ''
    #![enable(implicit_some)]
    #![enable(unwrap_newtypes)]
    #![enable(unwrap_variant_newtypes)]
    (
        address: "127.0.0.1:6600",
        password: None,
        theme: None,
        cache_dir: None,
        on_song_change: None,
        volume_step: 5,
        scrolloff: 0,
        wrap_navigation: false,
        enable_mouse: true,
        status_update_interval_ms: 1000,
        select_current_song_on_change: false,
        album_art: (
            method: Auto,
            max_size_px: (width: 600, height: 600),
        ),
        keybinds: (
            global: {
                ":":       CommandMode,
                ",":       VolumeDown,
                "s":       Stop,
                ".":       VolumeUp,
                "c":       ToggleSingle,
                "<Tab>":   NextTab,
                "<S-Tab>": PreviousTab,
                "1":       SwitchToTab("Queue"),
                "2":       SwitchToTab("Directories"),
                "3":       SwitchToTab("Artists"),
                "4":       SwitchToTab("Album Artists"),
                "5":       SwitchToTab("Albums"),
                "6":       SwitchToTab("Playlists"),
                "7":       SwitchToTab("Search"),
                "q":       Quit,
                "x":       ToggleRandom,
                ">":       NextTrack,
                "<":       PreviousTrack,
                "f":       SeekForward,
                "v":       ToggleConsume,
                "p":       TogglePause,
                "z":       ToggleRepeat,
                "b":       SeekBack,
                "~":       ShowHelp,
                "I":       ShowCurrentSongInfo,
                "O":       ShowOutputs,
            },
            navigation: {
                "k":       Up,
                "j":       Down,
                "h":       Left,
                "l":       Right,
                "<Up>":    Up,
                "<Down>":  Down,
                "<Left>":  Left,
                "<Right>": Right,
                "<C-k>":   PaneUp,
                "<C-j>":   PaneDown,
                "<C-h>":   PaneLeft,
                "<C-l>":   PaneRight,
                "<C-u>":   UpHalf,
                "N":       PreviousResult,
                "a":       Add,
                "A":       AddAll,
                "r":       Rename,
                "n":       NextResult,
                "g":       Top,
                "<Space>": Select,
                "G":       Bottom,
                "<CR>":    Confirm,
                "i":       FocusInput,
                "J":       MoveDown,
                "<C-d>":   DownHalf,
                "/":       EnterSearch,
                "<C-c>":   Close,
                "<Esc>":   Close,
                "K":       MoveUp,
                "D":       Delete,
            },
            queue: {
                "D":       DeleteAll,
                "<CR>":    Play,
                "<C-s>":   Save,
                "a":       AddToPlaylist,
                "d":       Delete,
                "i":       ShowInfo,
            },
        ),
        search: (
            case_sensitive: false,
            mode: Contains,
            tags: [
                (value: "any",         label: "Any Tag"),
                (value: "artist",      label: "Artist"),
                (value: "album",       label: "Album"),
                (value: "albumartist", label: "Album Artist"),
                (value: "title",       label: "Title"),
                (value: "filename",    label: "Filename"),
                (value: "genre",       label: "Genre"),
            ],
        ),
        tabs: [
            (
                name: "Queue",
                border_type: None,
                pane: Split(
                    direction: Horizontal,
                    panes: [(size: "40%", pane: Pane(AlbumArt)), (size: "60%", pane: Pane(Queue))],
                ),
            ),
            (
                name: "Directories",
                border_type: None,
                pane: Pane(Directories),
            ),
            (
                name: "Artists",
                border_type: None,
                pane: Pane(Artists),
            ),
            (
                name: "Album Artists",
                border_type: None,
                pane: Pane(AlbumArtists),
            ),
            (
                name: "Albums",
                border_type: None,
                pane: Pane(Albums),
            ),
            (
                name: "Playlists",
                border_type: None,
                pane: Pane(Playlists),
            ),
            (
                name: "Search",
                border_type: None,
                pane: Pane(Search),
            ),
        ],
    )
  '';
}
