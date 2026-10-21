{
  config,
  lib,
  ...
}: let
  cfg = config.host.niri;
in {
  config = lib.mkIf (cfg.enable && cfg.shell == "noctalia") {
    # noctalia has its own OSD and locks before suspend
    host.niri = {
      startup = lib.mkDefault [["noctalia"]];
      launcherCommand = lib.mkDefault ["noctalia" "msg" "panel-toggle" "launcher"];
      lockCommand = lib.mkDefault ["noctalia" "msg" "session" "lock"];
      volumeUpCommand = lib.mkDefault "noctalia msg volume-up";
      volumeDownCommand = lib.mkDefault "noctalia msg volume-down";
      volumeMuteCommand = lib.mkDefault "noctalia msg volume-mute";
      micMuteCommand = lib.mkDefault "noctalia msg mic-mute";
      brightnessUpCommand = lib.mkDefault "noctalia msg brightness-up";
      brightnessDownCommand = lib.mkDefault "noctalia msg brightness-down";
      playPauseCommand = lib.mkDefault "noctalia msg media toggle";
      stopCommand = lib.mkDefault "noctalia msg media stop";
    };

    # what the nixos programs.noctalia module sets
    xdg.sounds.enable = true;
    services.upower.enable = true;

    home-manager.users.${config.host.details.user} = {config, ...}: {
      # a unit would start under i3 too
      programs.noctalia = {
        enable = true;
        # the gui overrides these in settings.toml
        settings = {
          bar.default.end = [
            "media"
            "tray"
            "notifications"
            "clipboard"
            "network"
            "bluetooth"
            "volume"
            "brightness"
            "battery"
            "caffeine"
            "control-center"
            "session"
          ];
          control_center.shortcuts = map (type: {inherit type;}) [
            "wifi"
            "bluetooth"
            "caffeine"
            "notification"
            "power_profile"
            "mic_mute"
          ];
          location.auto_locate = true;
          notification.history_retention_hours = 1;
          shell = {
            font_family = "Fira Code";
            niri_overview_type_to_launch_enabled = true;
            greeter_sync.auto_sync = true;
            launcher = {
              app_grid = true;
              categories = false;
              compact = true;
              layout = "simple";
              show_app_actions = true;
              providers.emoji.global = false;
            };
            panel.launcher_placement = "attached";
            screenshot = {
              directory = "${config.home.homeDirectory}/Pictures/Screenshots";
              confirm_region = true;
            };
            window_switcher = {
              style = "compact";
              # mru = most recently used
              mru = true;
            };
          };
          theme = {
            source = "builtin";
            builtin = "Gruvbox";
            mode = "dark";
            # writes the palette to niri/noctalia.kdl
            templates.builtin_ids = ["niri"];
          };
          wallpaper = {
            directory = "${config.home.homeDirectory}/Pictures/wallpapers";
            transition_on_startup = true;
          };
        };
      };
      # noctalia is the notification daemon
      services.dunst.enable = false;
      user.wallpaper = {
        enable = true;
        updateCommands = ''
          if [ -n "''${NIRI_SOCKET:-}" ]; then
            noctalia msg wallpaper-set ${config.user.wallpaper.path}
            noctalia msg greeter-sync
          fi
        '';
      };
      # last, so the pallet overrides other stuff.
      wayland.windowManager.niri.extraConfig = ''include optional=true "noctalia.kdl"'';
      wayland.windowManager.niri.settings.binds = {
        # the shared titles would say "noctalia"
        "Mod+D"._props.hotkey-overlay-title = lib.mkForce "Run an Application: Noctalia Launcher";
        "Mod+X"._props.hotkey-overlay-title = lib.mkForce "Lock the Screen: Noctalia";
        "Mod+N" = {
          _props.hotkey-overlay-title = "Toggle the Control Center";
          spawn = ["noctalia" "msg" "panel-toggle" "control-center"];
        };
        "Mod+Shift+X" = {
          _props.hotkey-overlay-title = "Open the Session Menu";
          spawn = ["noctalia" "msg" "panel-toggle" "session"];
        };
        "Alt+Tab" = {
          _props.hotkey-overlay-title = "Switch Windows";
          spawn = ["noctalia" "msg" "window-switcher" "hold"];
        };
        "Mod+S" = {
          _props.hotkey-overlay-title = "Screenshot Screen";
          spawn = ["noctalia" "msg" "screenshot-fullscreen"];
        };
        "Mod+Ctrl+S" = {
          _props.hotkey-overlay-title = "Screenshot Selection";
          spawn = ["noctalia" "msg" "screenshot-region"];
        };
        "Mod+Shift+S" = {
          _props.hotkey-overlay-title = "Annotate the Screen";
          spawn = ["noctalia" "msg" "screenshot-annotate"];
        };
      };
    };
  };
}
