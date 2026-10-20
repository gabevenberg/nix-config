{config, ...}: {
  home-manager.users.${config.host.details.user} = {
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
          # battery states trigger at or below, unlike cpu and memory
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
}
