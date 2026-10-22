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

  directionKeys = {
    left = {
      letter = "H";
      arrow = "Left";
    };
    down = {
      letter = "J";
      arrow = "Down";
    };
    up = {
      letter = "K";
      arrow = "Up";
    };
    right = {
      letter = "L";
      arrow = "Right";
    };
  };
  # a title keeps it in the overlay even when niri does not count it as important
  titled = action: title: {
    _props.hotkey-overlay-title = title;
    ${action} = {};
  };
  # binds each direction to both its letter and its arrow, listing only the letter
  directional = mods: binds:
    lib.concatMapAttrs (direction: bind: {
      "${mods}+${directionKeys.${direction}.letter}" = bind;
      "${mods}+${directionKeys.${direction}.arrow}" = bind // {_props.hotkey-overlay-title = null;};
    })
    binds;
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
    playerVolumeUpCommand = command "raise the media player volume";
    playerVolumeDownCommand = command "lower the media player volume";
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
    }: {
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
            focus-follows-mouse._props.max-scroll-amount = "0%";
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
          # only list binds that exist
          hotkey-overlay.hide-not-bound = {};
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
              "Mod+Alt+L" = {
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
              "Mod+Shift+W" = titled "toggle-column-tabbed-display" "Toggle Tabbed Column";
              "Mod+X" = {
                _props.hotkey-overlay-title = "Lock the Screen: ${lib.head cfg.lockCommand}";
                spawn = cfg.lockCommand;
              };
              "Mod+Shift+P" = {
                _props.hotkey-overlay-title = "Open Volume Control: pwvucontrol";
                spawn = ["pwvucontrol"];
              };

              "Mod+A" = titled "focus-column-first" "Focus First Column";
              "Mod+E" = titled "focus-column-last" "Focus Last Column";
              "Mod+Ctrl+A" = titled "move-column-to-first" "Move Column to First";
              "Mod+Ctrl+E" = titled "move-column-to-last" "Move Column to Last";

              "Mod+BracketLeft" = titled "consume-or-expel-window-left" "Consume or Expel Window Left";
              "Mod+BracketRight" = titled "consume-or-expel-window-right" "Consume or Expel Window Right";
              "Mod+Comma" = titled "consume-window-into-column" "Consume Window into Column";
              "Mod+Period" = titled "expel-window-from-column" "Expel Window from Column";

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

              "Mod+U" = titled "focus-workspace-down" "Focus Workspace Down";
              "Mod+I" = titled "focus-workspace-up" "Focus Workspace Up";
              "Mod+Ctrl+U" = titled "move-column-to-workspace-down" "Move Column to Workspace Down";
              "Mod+Ctrl+I" = titled "move-column-to-workspace-up" "Move Column to Workspace Up";

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
                spawn-sh = cfg.playerVolumeUpCommand;
              };
              "Mod+Alt+Minus" = {
                _props.hotkey-overlay-title = "Player Volume Down";
                spawn-sh = cfg.playerVolumeDownCommand;
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
            # step past the edge of the column or workspace instead of stopping
            // directional "Mod" {
              left = titled "focus-column-or-monitor-left" "Focus Column or Monitor Left";
              down = titled "focus-window-or-workspace-down" "Focus Window or Workspace Down";
              up = titled "focus-window-or-workspace-up" "Focus Window or Workspace Up";
              right = titled "focus-column-or-monitor-right" "Focus Column or Monitor Right";
            }
            // directional "Mod+Ctrl" {
              left = titled "move-column-left-or-to-monitor-left" "Move Column Left or to Monitor Left";
              down = titled "move-window-down-or-to-workspace-down" "Move Window Down or to Workspace Down";
              up = titled "move-window-up-or-to-workspace-up" "Move Window Up or to Workspace Up";
              right = titled "move-column-right-or-to-monitor-right" "Move Column Right or to Monitor Right";
            }
            // directional "Mod+Shift" {
              left = titled "focus-monitor-left" "Focus Monitor Left";
              down = titled "focus-monitor-down" "Focus Monitor Down";
              up = titled "focus-monitor-up" "Focus Monitor Up";
              right = titled "focus-monitor-right" "Focus Monitor Right";
            }
            // directional "Mod+Shift+Ctrl" {
              left = titled "move-column-to-monitor-left" "Move Column to Monitor Left";
              down = titled "move-column-to-monitor-down" "Move Column to Monitor Down";
              up = titled "move-column-to-monitor-up" "Move Column to Monitor Up";
              right = titled "move-column-to-monitor-right" "Move Column to Monitor Right";
            }
            # monitors only ever sit side by side, so up and down are free to reorder workspaces
            // directional "Mod+Shift+Alt" {
              left = titled "move-workspace-to-monitor-left" "Move Workspace to Monitor Left";
              down = titled "move-workspace-down" "Move Workspace Down";
              up = titled "move-workspace-up" "Move Workspace Up";
              right = titled "move-workspace-to-monitor-right" "Move Workspace to Monitor Right";
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
