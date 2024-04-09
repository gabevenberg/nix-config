{
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager.users.${config.host.user} = {
    config,
    osConfig,
    lib,
    ...
  }: {
    programs.i3status-rust = {
      enable = true;
      bars = {
        default = {
          blocks = [
            {
              block = "music";
              format = " $icon {$combo.str(max_w:25,rot_interval:0.5) $play $next $prev $player.str(max_w:5,rot_interval:0.5) [$cur/$avail] |} ";
            }
            {
              block = "memory";
              format = " $icon $mem_used_percents ";
              format_alt = " $icon $swap_used_percents (swap)";
            }
            {
              block = "cpu";
              interval = 1;
            }
            {
              block = "load";
              format = " $icon $1m ";
              interval = 1;
            }
            (
              lib.mkIf
              (!osConfig.host.isVm)
              {block = "backlight";}
            )
            (
              lib.mkIf (osConfig.host.isLaptop)
              {
                block = "battery";
                driver = "upower";
                format = "$icon $percentage {$time |}";
              }
            )
            {
              block = "net";
              format = "$icon {$signal_strength $ssid.str(max_w:5,rot_interval:0.5)|}";
              format_alt = " $icon {$signal_strength $ssid.str(max_w:5,rot_interval:0.5) $frequency|} $ip | $ipv6 via $device";
            }
            {
              block = "sound";
              format = "$icon {$volume.bar(v:true) $volume.eng(w:2) |}";
              headphones_indicator = true;
              click = [
                {
                  button = "left";
                  cmd = "pwvucontrol";
                }
              ];
            }
            {
              block = "time";
              format = " $timestamp.datetime(f:'%F %R') ";
              interval = 60;
            }
          ];
          theme = "gruvbox-dark";
          icons = "material-nf";
        };
      };
    };
  };
}
