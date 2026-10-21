{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.host.niri;
  wallpaper = config.home-manager.users.${config.host.details.user}.user.wallpaper.path;
  notifyVolume = "${cfg.notifyCommand} -t 1000 -h string:x-canonical-private-synchronous:volume -h int:value:$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100}') Volume";
  notifyBrightness = "${cfg.notifyCommand} -h string:x-canonical-private-synchronous:brightness -t 500 Brightness\\ $(brightnessctl -m | cut -d, -f4)";
  notifyPlayer = "${cfg.notifyCommand} -h string:x-canonical-private-synchronous:playerstatus -t 500 Player $(playerctl status)";
in {
  config = lib.mkIf (cfg.enable && cfg.shell == "vanilla") {
    host.niri = {
      startup = lib.mkDefault [
        ["swaybg" "--mode" "fill" "--image" wallpaper]
        ["swayidle" "-w" "before-sleep" "swaylock -f"]
        ["waybar"]
      ];
      launcherCommand = lib.mkDefault ["fuzzel"];
      lockCommand = lib.mkDefault ["swaylock"];
      volumeUpCommand = lib.mkDefault "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 1%+; ${notifyVolume}";
      volumeDownCommand = lib.mkDefault "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-; ${notifyVolume}";
      volumeMuteCommand = lib.mkDefault "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle; ${cfg.notifyCommand} -t 1000 -h string:x-canonical-private-synchronous:volume \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@)\"";
      micMuteCommand = lib.mkDefault "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle; ${cfg.notifyCommand} -t 1000 -h string:x-canonical-private-synchronous:mic \"Mic $(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)\"";
      brightnessUpCommand = lib.mkDefault "brightnessctl s +1%; ${notifyBrightness}";
      brightnessDownCommand = lib.mkDefault "brightnessctl s 1%-; ${notifyBrightness}";
      playPauseCommand = lib.mkDefault "playerctl play-pause; ${notifyPlayer}";
      stopCommand = lib.mkDefault "playerctl stop; ${notifyPlayer}";
    };

    # only the sway module sets this up
    security.pam.services.swaylock = {};

    home-manager.users.${config.host.details.user} = {config, ...}: {
      home.packages = with pkgs; [
        swaybg
        swayidle
      ];
      user.wallpaper = {
        enable = true;
        updateCommands = ''
          if [ -n "''${NIRI_SOCKET:-}" ]; then
            pkill -x swaybg || true
            niri msg action spawn -- swaybg --mode fill --image ${config.user.wallpaper.path}
          fi
        '';
      };
      # ctrl+c in the selection ui skips saving to disk
      wayland.windowManager.niri.settings.binds = {
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
      };
      programs.fuzzel.enable = true;
      programs.swaylock = {
        enable = true;
        settings = {
          image = config.user.wallpaper.path;
          show-failed-attempts = true;
        };
      };
      # niri's default config spawns it, a unit would start under i3 too
      programs.waybar = {
        enable = true;
        settings.main = {
          position = "bottom";
          modules-left = ["niri/workspaces" "niri/window"];
          modules-right = ["mpris" "memory" "cpu" "load" "backlight" "battery" "network" "wireplumber" "tray" "clock"];
          mpris = {
            format = "{player_icon} {dynamic}";
            dynamic-len = 25;
          };
          memory = {
            format = "󰍛 {percentage}%";
            states = {
              warning = 70;
              critical = 90;
            };
          };
          cpu = {
            format = "󰻠 {usage}%";
            states = {
              warning = 70;
              critical = 90;
            };
          };
          load.format = "󰊚 {load1}";
          backlight.format = "󰃠 {percent}%";
          battery = {
            format = "{icon} {capacity}% {time}";
            format-charging = "󰂄 {capacity}% {time}";
            format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            states = {
              warning = 30;
              critical = 15;
            };
          };
          network = {
            format-wifi = "󰖩 {essid} {signalStrength}%";
            format-ethernet = "󰈀 {ifname}";
            format-disconnected = "󰖪 offline";
          };
          wireplumber = {
            format = "󰕾 {volume}%";
            format-muted = "󰝟 muted";
            on-click = "pwvucontrol";
          };
          clock.format = "󰥔 {:%a %Y-%m-%d %H:%M}";
        };
        style = ''
          * {
            font-family: "Fira Code", "Symbols Nerd Font";
            font-size: 13px;
            min-height: 0;
          }
          window#waybar {
            background: #282828;
            color: #ebdbb2;
          }
          #workspaces button {
            padding: 0 6px;
            color: #a89984;
            border-radius: 0;
          }
          #workspaces button.active {
            color: #282828;
            background: #458588;
          }
          #window {
            padding: 0 8px;
          }
          #mpris, #memory, #cpu, #load, #backlight, #battery,
          #network, #wireplumber, #tray, #clock {
            padding: 0 8px;
            border-left: 1px solid #504945;
          }
          #battery.warning, #memory.warning, #cpu.warning {
            color: #282828;
            background: #d79921;
          }
          #battery.critical, #memory.critical, #cpu.critical,
          #network.disconnected, #wireplumber.muted {
            color: #282828;
            background: #cc241d;
          }
        '';
      };
    };
  };
}
