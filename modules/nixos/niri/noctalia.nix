{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.host.niri;
  steam = config.programs.steam.enable;
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
      playerVolumeUpCommand = lib.mkDefault "playerctl volume 0.01+";
      playerVolumeDownCommand = lib.mkDefault "playerctl volume 0.01-";
    };

    # firefox needs the pywalfox add-on for noctalia's colours.
    programs.firefox.nativeMessagingHosts.packages = [
      (pkgs.writeTextDir "lib/mozilla/native-messaging-hosts/pywalfox.json" (builtins.toJSON {
        name = "pywalfox";
        # noctalia checks this
        description = "Noctalia Firefox theme native messaging host";
        path = lib.getExe' pkgs.noctalia "noctalia";
        type = "stdio";
        allowed_extensions = ["pywalfox@frewacom.org"];
      }))
    ];

    # loads steam themes; Material-Theme reads noctalia's colours
    nixpkgs.overlays = lib.mkIf steam [inputs.millennium.overlays.default];
    programs.steam.package = lib.mkIf steam pkgs.millennium-steam;

    # what the nixos programs.noctalia module sets
    xdg.sounds.enable = true;
    services.upower.enable = true;

    home-manager.users.${config.host.details.user} = {
      config,
      pkgs,
      ...
    }: {
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
            # their setup scripts edit home-manager's files
            templates = {
              enable_builtin_templates = false;
              enable_community_templates = false;
              user = lib.mapAttrs (_: target:
                {
                  input_path = "${target.template}";
                  output_path = "~/${target.path}";
                }
                // lib.optionalAttrs (target.reload != null) {post_hook = target.reload;}
                // lib.optionalAttrs (target.postAction != null) {post_action = target.postAction;})
              config.user.theme.targets;
            };
          };
          wallpaper = {
            directory = "${config.home.homeDirectory}/Pictures/wallpapers";
            transition_on_startup = true;
          };
        };
      };
      # noctalia is the notification daemon
      services.dunst.enable = false;
      wrappers.neovim.settings.colorscheme = "noctalia";
      user.theme = {
        noctalia = true;
        targets = {
          niri = {
            template = "${pkgs.noctalia}/share/noctalia/assets/templates/niri/niri.kdl";
            path = ".config/niri/noctalia.kdl";
          };
          nvim = {
            template = ../../home-manager/theme/templates/nvim.lua;
            path = ".cache/noctalia/nvim.lua";
            reload = "pkill -USR1 -x nvim || true";
          };
          pywalfox = {
            template = ../../home-manager/theme/templates/pywalfox.json;
            path = ".cache/wal/colors.json";
            postAction = "firefox-theme";
          };
          # millennium can delete this on a theme update
          steam = lib.mkIf steam {
            template = ../../home-manager/theme/templates/steam.css;
            path = ".steam/steam/steamui/skins/Material-Theme/css/main/colors/matugen.css";
          };
        };
      };
      user.wallpaper = {
        enable = true;
        updateCommands = ''
          if [ -n "''${NIRI_SOCKET:-}" ]; then
            # the original, since noctalia ignores a path it already has
            noctalia msg wallpaper-set "$(realpath -- "$1")"
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
