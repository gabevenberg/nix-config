{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  # only the sway module sets this up
  security.pam.services.swaylock = {};

  xdg.portal = {
    extraPortals = [pkgs.xdg-desktop-portal-termfilechooser];
    config.niri."org.freedesktop.impl.portal.FileChooser" = lib.mkForce "termfilechooser";
  };

  home-manager.users.${config.host.details.user} = {
    config,
    osConfig,
    ...
  }: let
    wallpaper = config.user.wallpaper.path;
    notify = "${pkgs.dunst}/bin/dunstify";
    # shared by the Mod binds and the hardware media keys
    notifyVolume = "${notify} --expire-time=1000 --stack-tag volume -h int:value:$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100}') Volume";
    volumeUp = "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 1%+; ${notifyVolume}";
    volumeDown = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-; ${notifyVolume}";
    notifyBrightness = "${notify} --stack-tag brightness --expire-time=500 Brightness\\ $(brightnessctl -m | cut -d, -f4)";
    brightnessUp = "brightnessctl s +1%; ${notifyBrightness}";
    brightnessDown = "brightnessctl s 1%-; ${notifyBrightness}";
    playPause = "playerctl play-pause; ${notify} --stack-tag playerstatus --expire-time=500 Player $(playerctl status)";
  in {
    home.packages = with pkgs; [
      wl-clipboard
      wireplumber
      playerctl
      brightnessctl
      swaybg
      swayidle
    ];
    user.wallpaper = {
      enable = true;
      updateCommands = ''
        if [ -n "''${NIRI_SOCKET:-}" ]; then
          pkill -x swaybg || true
          niri msg action spawn -- swaybg --mode fill --image ${wallpaper}
        fi
      '';
    };
    programs.fuzzel.enable = true;
    programs.swaylock = {
      enable = true;
      settings = {
        image = wallpaper;
        show-failed-attempts = true;
      };
    };
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
          # gruvbox, to match waybar
          focus-ring = {
            width = 2;
            active-color = "#458588";
            inactive-color = "#504945";
          };
        };
        cursor = {
          xcursor-theme = config.home.pointerCursor.name;
          xcursor-size = config.home.pointerCursor.size;
        };
        screenshot-path ="~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
        spawn-at-startup = ["swaybg" "--mode" "fill" "--image" wallpaper];
        _children = [
          {spawn-at-startup = ["swayidle" "-w" "before-sleep" "swaylock -f"];}
          {spawn-at-startup = ["waybar"];}
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
              _props.hotkey-overlay-title = "Run an Application: fuzzel";
              spawn = ["fuzzel"];
            };
            "Super+Alt+L" = {
              _props.hotkey-overlay-title = null;
              spawn = ["swaylock"];
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
            # lets a VM or remote desktop take every shortcut, this one excepted
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
              _props.hotkey-overlay-title = "Lock the Screen: swaylock";
              spawn = ["swaylock"];
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

            # ctrl+c in the selection ui skips saving to disk
            "Mod+S" = {
              _props.hotkey-overlay-title = "Screenshot Screen to Clipboard";
              screenshot-screen._props.write-to-disk = false;
            };
            "Mod+Shift+S" = {
              _props.hotkey-overlay-title = "Screenshot Window to Clipboard";
              screenshot-window._props.write-to-disk = false;
            };
            "Mod+Ctrl+S" = {
              _props.hotkey-overlay-title = "Screenshot Selection (Ctrl+C in it skips disk)";
              screenshot = {};
            };
            "Mod+Alt+S" = {
              _props.hotkey-overlay-title = "Screenshot Screen to Clipboard and Disk";
              screenshot-screen = {};
            };
            "Mod+Alt+Shift+S" = {
              _props.hotkey-overlay-title = "Screenshot Window to Clipboard and Disk";
              screenshot-window = {};
            };
            "Mod+Alt+Ctrl+S".screenshot = {};

            "Mod+Ctrl+Equal" = {
              _props = {
                allow-when-locked = true;
                hotkey-overlay-title = "Volume Up";
              };
              spawn-sh = volumeUp;
            };
            "Mod+Ctrl+Minus" = {
              _props = {
                allow-when-locked = true;
                hotkey-overlay-title = "Volume Down";
              };
              spawn-sh = volumeDown;
            };
            "Mod+Ctrl+Shift+Equal" = {
              _props.hotkey-overlay-title = "Brightness Up";
              spawn-sh = brightnessUp;
            };
            "Mod+Ctrl+Shift+Minus" = {
              _props.hotkey-overlay-title = "Brightness Down";
              spawn-sh = brightnessDown;
            };
            "Mod+Alt+P" = {
              _props.hotkey-overlay-title = "Play/Pause";
              spawn-sh = playPause;
            };
            "Mod+Alt+Equal" = {
              _props.hotkey-overlay-title = "Player Volume Up";
              spawn-sh = "playerctl volume 0.01+; ${notify} --stack-tag volume --expire-time=500 -h int:value:$(playerctl volume | awk '{print $1*100}') Player";
            };
            "Mod+Alt+Minus" = {
              _props.hotkey-overlay-title = "Player Volume Down";
              spawn-sh = "playerctl volume 0.01-; ${notify} --stack-tag volume --expire-time=500 -h int:value:$(playerctl volume | awk '{print $1*100}') Player";
            };

            # the Mod binds above already list these in the overlay
            "XF86AudioRaiseVolume" = {
              _props = {
                allow-when-locked = true;
                hotkey-overlay-title = null;
              };
              spawn-sh = volumeUp;
            };
            "XF86AudioLowerVolume" = {
              _props = {
                allow-when-locked = true;
                hotkey-overlay-title = null;
              };
              spawn-sh = volumeDown;
            };
            "XF86AudioMute" = {
              _props = {
                allow-when-locked = true;
                hotkey-overlay-title = null;
              };
              spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle; ${notify} --expire-time=1000 --stack-tag volume \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@)\"";
            };
            "XF86AudioMicMute" = {
              _props = {
                allow-when-locked = true;
                hotkey-overlay-title = null;
              };
              spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle; ${notify} --expire-time=1000 --stack-tag mic \"Mic $(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)\"";
            };
            "XF86AudioPlay" = {
              _props = {
                allow-when-locked = true;
                hotkey-overlay-title = null;
              };
              spawn-sh = playPause;
            };
            "XF86AudioStop" = {
              _props = {
                allow-when-locked = true;
                hotkey-overlay-title = null;
              };
              spawn-sh = "playerctl stop; ${notify} --stack-tag playerstatus --expire-time=500 Player $(playerctl status)";
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
              spawn-sh = brightnessUp;
            };
            "XF86MonBrightnessDown" = {
              _props = {
                allow-when-locked = true;
                hotkey-overlay-title = null;
              };
              spawn-sh = brightnessDown;
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
  imports = [
    ./waybar.nix
    ../graphical.nix
  ];
}
