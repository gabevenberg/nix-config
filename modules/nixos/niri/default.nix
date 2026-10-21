{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.host.niri;
  command = description:
    lib.mkOption {
      type = lib.types.str;
      inherit description;
    };
in {
  options.host.niri = {
    enable = lib.mkEnableOption "niri";
    shell = lib.mkOption {
      type = lib.types.enum ["noctalia" "vanilla"];
      default = "vanilla";
      description = "desktop shell to run on niri, sets the defaults for the commands below";
    };

    startup = lib.mkOption {
      type = lib.types.listOf (lib.types.listOf lib.types.str);
      description = "commands spawned at niri startup, each as an argv list";
    };
    launcherCommand = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "application launcher, as an argv list";
    };
    lockCommand = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "screen locker, as an argv list";
    };
    focusRing = {
      activeColor = lib.mkOption {
        type = lib.types.str;
        default = "#458588";
        description = "focus ring colour of the focused window";
      };
      inactiveColor = lib.mkOption {
        type = lib.types.str;
        default = "#504945";
        description = "focus ring colour of unfocused windows";
      };
    };
    notifyCommand = lib.mkOption {
      type = lib.types.str;
      default = "${pkgs.libnotify}/bin/notify-send";
      description = "shell prefix used to send a notification, takes notify-send arguments";
    };

    # the rest are shell commands, so the vanilla ones can notify afterwards
    volumeUpCommand = command "raise the speaker volume";
    volumeDownCommand = command "lower the speaker volume";
    volumeMuteCommand = command "toggle speaker mute";
    micMuteCommand = command "toggle microphone mute";
    brightnessUpCommand = command "raise the screen brightness";
    brightnessDownCommand = command "lower the screen brightness";
    playPauseCommand = command "toggle media playback";
    stopCommand = command "stop media playback";
  };

  config = lib.mkIf cfg.enable {
    host.greeter = lib.mkDefault (
      if cfg.shell == "noctalia"
      then "noctalia"
      else "regreet"
    );
    programs.niri = {
      enable = true;
      useNautilus = false;
    };
    # noctalia's power widget uses it, and so does powerprofilesctl
    services.power-profiles-daemon.enable = lib.mkDefault config.host.details.isLaptop;

    xdg.portal = {
      extraPortals = [pkgs.xdg-desktop-portal-termfilechooser];
      config.niri."org.freedesktop.impl.portal.FileChooser" = lib.mkForce "termfilechooser";
    };

    home-manager.users.${config.host.details.user} = {
      config,
      osConfig,
      ...
    }: let
      playerVolume = "${cfg.notifyCommand} -h string:x-canonical-private-synchronous:volume -t 500 -h int:value:$(playerctl volume | awk '{print $1*100}') Player";
    in {
      home.packages = with pkgs; [
        wl-clipboard
        wireplumber
        playerctl
        brightnessctl
        wdisplays
        kanshi
      ];
      wayland.windowManager.niri = {
        enable = true;
        # the niri nixos module already ships systemd units.
        systemd.enable = false;
        portalPackage = null;
        # its binds crowd the hotkey overlay, so the parts worth keeping are ported below
        enableDefaultConfig = false;
        settings = {
          input = {
            keyboard = {
              xkb.options = osConfig.services.xserver.xkb.options;
              numlock = {};
            };
            touchpad = {
              tap = {};
              natural-scroll = {};
            };
          };
          layout = {
            gaps = 16;
            center-focused-column = "never";
            preset-column-widths._children = [
              {proportion = 0.33333;}
              {proportion = 0.5;}
              {proportion = 0.66667;}
            ];
            default-column-width.proportion = 0.5;
            focus-ring = {
              width = 2;
              active-color = cfg.focusRing.activeColor;
              inactive-color = cfg.focusRing.inactiveColor;
            };
          };
          cursor = {
            xcursor-theme = config.home.pointerCursor.name;
            xcursor-size = config.home.pointerCursor.size;
          };
          screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
          _children =
            map (argv: {spawn-at-startup = argv;}) cfg.startup
            ++ [
              {
                window-rule._children = [
                  {
                    match._props = {
                      app-id = "firefox$";
                      title = "^Picture-in-Picture$";
                    };
                  }
                  {open-floating = true;}
                ];
              }
              {
                window-rule = {
                  geometry-corner-radius = 6;
                  clip-to-geometry = true;
                };
              }
            ];
          binds =
            {
              "Mod+Shift+Slash".show-hotkey-overlay = {};
              "Mod+D" = {
                _props.hotkey-overlay-title = "Run an Application: ${lib.head cfg.launcherCommand}";
                spawn = cfg.launcherCommand;
              };
              "Super+Alt+L" = {
                _props.hotkey-overlay-title = null;
                spawn = cfg.lockCommand;
              };
              "Mod+O" = {
                _props.repeat = false;
                toggle-overview = {};
              };
              "Mod+Q" = {
                _props.repeat = false;
                close-window = {};
              };
              "Mod+Shift+E".quit = {};
              "Ctrl+Alt+Delete".quit = {};

              # lets a VM or remote desktop take over shortcuts (except this one)
              "Mod+Escape" = {
                _props.allow-inhibiting = false;
                toggle-keyboard-shortcuts-inhibit = {};
              };
              "Mod+Ctrl+Shift+P".power-off-monitors = {};

              "Mod+Return" = {
                _props.hotkey-overlay-title = "Open a Terminal: kitty";
                spawn = ["kitty"];
              };
              "Mod+T" = {
                _props.hotkey-overlay-title = null;
                spawn = ["kitty"];
              };

              "Mod+W" = {
                _props.hotkey-overlay-title = "Open Firefox";
                spawn = ["firefox"];
              };
              "Mod+Shift+W" = {
                _props.hotkey-overlay-title = "Toggle Tabbed Column";
                toggle-column-tabbed-display = {};
              };
              "Mod+X" = {
                _props.hotkey-overlay-title = "Lock the Screen: ${lib.head cfg.lockCommand}";
                spawn = cfg.lockCommand;
              };
              "Mod+Shift+P" = {
                _props.hotkey-overlay-title = "Open Volume Control: pwvucontrol";
                spawn = ["pwvucontrol"];
              };

              "Mod+A" = {
                _props.hotkey-overlay-title = "Focus First Column";
                focus-column-first = {};
              };
              "Mod+E" = {
                _props.hotkey-overlay-title = "Focus Last Column";
                focus-column-last = {};
              };
              "Mod+Ctrl+A" = {
                _props.hotkey-overlay-title = "Move Column to First";
                move-column-to-first = {};
              };
              "Mod+Ctrl+E" = {
                _props.hotkey-overlay-title = "Move Column to Last";
                move-column-to-last = {};
              };
              # step past the edge of the column or workspace instead of stopping
              "Mod+H".focus-column-or-monitor-left = {};
              "Mod+J".focus-window-or-workspace-down = {};
              "Mod+K".focus-window-or-workspace-up = {};
              "Mod+L".focus-column-or-monitor-right = {};
              "Mod+Ctrl+H".move-column-left-or-to-monitor-left = {};
              "Mod+Ctrl+J".move-window-down-or-to-workspace-down = {};
              "Mod+Ctrl+K".move-window-up-or-to-workspace-up = {};
              "Mod+Ctrl+L".move-column-right-or-to-monitor-right = {};
              "Mod+Left".focus-column-or-monitor-left = {};
              "Mod+Down".focus-window-or-workspace-down = {};
              "Mod+Up".focus-window-or-workspace-up = {};
              "Mod+Right".focus-column-or-monitor-right = {};
              "Mod+Ctrl+Left".move-column-left-or-to-monitor-left = {};
              "Mod+Ctrl+Down".move-window-down-or-to-workspace-down = {};
              "Mod+Ctrl+Up".move-window-up-or-to-workspace-up = {};
              "Mod+Ctrl+Right".move-column-right-or-to-monitor-right = {};

              "Mod+Shift+Left".focus-monitor-left = {};
              "Mod+Shift+Down".focus-monitor-down = {};
              "Mod+Shift+Up".focus-monitor-up = {};
              "Mod+Shift+Right".focus-monitor-right = {};
              "Mod+Shift+H".focus-monitor-left = {};
              "Mod+Shift+J".focus-monitor-down = {};
              "Mod+Shift+K".focus-monitor-up = {};
              "Mod+Shift+L".focus-monitor-right = {};
              "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = {};
              "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = {};
              "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = {};
              "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = {};
              "Mod+Shift+Ctrl+H".move-column-to-monitor-left = {};
              "Mod+Shift+Ctrl+J".move-column-to-monitor-down = {};
              "Mod+Shift+Ctrl+K".move-column-to-monitor-up = {};
              "Mod+Shift+Ctrl+L".move-column-to-monitor-right = {};

              "Mod+BracketLeft".consume-or-expel-window-left = {};
              "Mod+BracketRight".consume-or-expel-window-right = {};
              "Mod+Comma".consume-window-into-column = {};
              "Mod+Period".expel-window-from-column = {};

              "Mod+R".switch-preset-column-width = {};
              "Mod+Shift+R".switch-preset-column-width-back = {};
              "Mod+Ctrl+Shift+R".switch-preset-window-height = {};
              "Mod+Ctrl+R".reset-window-height = {};
              "Mod+Minus".set-column-width = "-10%";
              "Mod+Equal".set-column-width = "+10%";
              "Mod+Shift+Minus".set-window-height = "-10%";
              "Mod+Shift+Equal".set-window-height = "+10%";

              "Mod+F".maximize-column = {};
              "Mod+Shift+F".fullscreen-window = {};
              "Mod+M".maximize-window-to-edges = {};
              "Mod+Ctrl+F".expand-column-to-available-width = {};
              "Mod+C".center-column = {};
              "Mod+Ctrl+C".center-visible-columns = {};

              "Mod+V".toggle-window-floating = {};
              "Mod+Shift+V".switch-focus-between-floating-and-tiling = {};

              "Mod+U".focus-workspace-down = {};
              "Mod+I".focus-workspace-up = {};
              "Mod+Ctrl+U".move-column-to-workspace-down = {};
              "Mod+Ctrl+I".move-column-to-workspace-up = {};
              "Mod+Shift+U".move-workspace-down = {};
              "Mod+Shift+I".move-workspace-up = {};

              "Mod+Ctrl+Equal" = {
                _props = {
                  allow-when-locked = true;
                  hotkey-overlay-title = "Volume Up";
                };
                spawn-sh = cfg.volumeUpCommand;
              };
              "Mod+Ctrl+Minus" = {
                _props = {
                  allow-when-locked = true;
                  hotkey-overlay-title = "Volume Down";
                };
                spawn-sh = cfg.volumeDownCommand;
              };
              "Mod+Ctrl+Shift+Equal" = {
                _props.hotkey-overlay-title = "Brightness Up";
                spawn-sh = cfg.brightnessUpCommand;
              };
              "Mod+Ctrl+Shift+Minus" = {
                _props.hotkey-overlay-title = "Brightness Down";
                spawn-sh = cfg.brightnessDownCommand;
              };
              "Mod+Alt+P" = {
                _props.hotkey-overlay-title = "Play/Pause";
                spawn-sh = cfg.playPauseCommand;
              };
              "Mod+Alt+Equal" = {
                _props.hotkey-overlay-title = "Player Volume Up";
                spawn-sh = "playerctl volume 0.01+; ${playerVolume}";
              };
              "Mod+Alt+Minus" = {
                _props.hotkey-overlay-title = "Player Volume Down";
                spawn-sh = "playerctl volume 0.01-; ${playerVolume}";
              };

              # the Mod binds above already list these in the overlay
              "XF86AudioRaiseVolume" = {
                _props = {
                  allow-when-locked = true;
                  hotkey-overlay-title = null;
                };
                spawn-sh = cfg.volumeUpCommand;
              };
              "XF86AudioLowerVolume" = {
                _props = {
                  allow-when-locked = true;
                  hotkey-overlay-title = null;
                };
                spawn-sh = cfg.volumeDownCommand;
              };
              "XF86AudioMute" = {
                _props = {
                  allow-when-locked = true;
                  hotkey-overlay-title = null;
                };
                spawn-sh = cfg.volumeMuteCommand;
              };
              "XF86AudioMicMute" = {
                _props = {
                  allow-when-locked = true;
                  hotkey-overlay-title = null;
                };
                spawn-sh = cfg.micMuteCommand;
              };
              "XF86AudioPlay" = {
                _props = {
                  allow-when-locked = true;
                  hotkey-overlay-title = null;
                };
                spawn-sh = cfg.playPauseCommand;
              };
              "XF86AudioStop" = {
                _props = {
                  allow-when-locked = true;
                  hotkey-overlay-title = null;
                };
                spawn-sh = cfg.stopCommand;
              };
              "XF86AudioPrev" = {
                _props = {
                  allow-when-locked = true;
                  hotkey-overlay-title = null;
                };
                spawn = ["playerctl" "previous"];
              };
              "XF86AudioNext" = {
                _props = {
                  allow-when-locked = true;
                  hotkey-overlay-title = null;
                };
                spawn = ["playerctl" "next"];
              };
              "XF86MonBrightnessUp" = {
                _props = {
                  allow-when-locked = true;
                  hotkey-overlay-title = null;
                };
                spawn-sh = cfg.brightnessUpCommand;
              };
              "XF86MonBrightnessDown" = {
                _props = {
                  allow-when-locked = true;
                  hotkey-overlay-title = null;
                };
                spawn-sh = cfg.brightnessDownCommand;
              };
            }
            // lib.mergeAttrsList (map (n: {
              "Mod+${toString n}".focus-workspace = n;
              "Mod+Ctrl+${toString n}".move-column-to-workspace = n;
            }) (lib.range 1 9));
        };
      };
      # see graphical.nix.
      xdg.configFile."niri-mimeapps.list".source = config.xdg.configFile."mimeapps.list".source;
      xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
        [filechooser]
        cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
        default_dir=$HOME
        open_mode=suggested
        save_mode=suggested
      '';
    };
  };

  imports = [
    ./noctalia.nix
    ./vanilla.nix
  ];
}
