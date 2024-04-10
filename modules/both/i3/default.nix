{
  config,
  pkgs,
  lib,
  ...
}: {
  services.accounts-daemon.enable = true;
  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "none+i3";
      lightdm = {
        enable = true;
      };
    };
    windowManager.i3.enable = true;
  };
  home-manager.users.${config.host.user} = {config, ...}: {
    home.packages = with pkgs; [
      maim
      brightnessctl
    ];
    services.playerctld.enable = true;
    xsession.enable = true;
    xsession.windowManager.i3 = let
      mod = "Mod4";

      ws1 = "1";
      ws2 = "2";
      ws3 = "3";
      ws4 = "4";
      ws5 = "5";
      ws6 = "6";
      ws7 = "7";
      ws8 = "8";
      ws9 = "9";
      ws10 = "10";
    in {
      enable = true;
      config = {
        modifier = mod;
        terminal = "kitty";
        menu = "rofi -show drun";
        defaultWorkspace = "workspace ${ws1}";
        keybindings = {
          "${mod}+Return" = "exec ${config.xsession.windowManager.i3.config.terminal}";
          "${mod}+d" = "exec ${config.xsession.windowManager.i3.config.menu}";
          "${mod}+Shift+q" = "kill";

          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";

          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";

          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

          "${mod}+Shift+semicolon" = "split v";
          "${mod}+Shift+backslash" = "split h";
          "${mod}+f" = "fullscreen toggle";

          "${mod}+e" = "layout stacking";
          "${mod}+r" = "layout tabbed";
          "${mod}+t" = "layout toggle split";

          "${mod}+Shift+space" = "floating toggle";
          "${mod}+space" = "focus mode_toggle";

          "${mod}+a" = "focus parent";

          "${mod}+Shift+o" = "move scratchpad";
          "${mod}+o" = "scratchpad show";

          "${mod}+1" = "workspace ${ws1}";
          "${mod}+2" = "workspace ${ws2}";
          "${mod}+3" = "workspace ${ws3}";
          "${mod}+4" = "workspace ${ws4}";
          "${mod}+5" = "workspace ${ws5}";
          "${mod}+6" = "workspace ${ws6}";
          "${mod}+7" = "workspace ${ws7}";
          "${mod}+8" = "workspace ${ws8}";
          "${mod}+9" = "workspace ${ws9}";
          "${mod}+0" = "workspace ${ws10}";

          "${mod}+Shift+1" = "move container to workspace ${ws1}";
          "${mod}+Shift+2" = "move container to workspace ${ws2}";
          "${mod}+Shift+3" = "move container to workspace ${ws3}";
          "${mod}+Shift+4" = "move container to workspace ${ws4}";
          "${mod}+Shift+5" = "move container to workspace ${ws5}";
          "${mod}+Shift+6" = "move container to workspace ${ws6}";
          "${mod}+Shift+7" = "move container to workspace ${ws7}";
          "${mod}+Shift+8" = "move container to workspace ${ws8}";
          "${mod}+Shift+9" = "move container to workspace ${ws9}";
          "${mod}+Shift+0" = "move container to workspace ${ws10}";

          "${mod}+Shift+n" = "reload";
          "${mod}+Shift+r" = "restart";
          "${mod}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

          "${mod}+ctrl+r" = "mode resize";

          # disable screen going to sleep with mod+b, enable screen going to sleep with mod+shift+b
          "${mod}+b" = ''
            exec --no-startup-id "xset s off -dpms; dunstify --timeout=500 'screen blanking off'"
          '';
          "${mod}+shift+b" = ''
            exec --no-startup-id "xset +dpms; dunstify --timeout=500 'screen blanking on'"
          '';
          # change brightness
          "${mod}+control+plus" = ''
            exec --no-startup-id "brightnessctl s +1%; dunstify -h string:x-dunst-stack-tag:brightness --timeout=500 Brightness\ $(brightnessctl -m | cut --delimiter=, -f 4)"
          '';
          "${mod}+control+minus" = ''
            exec --no-startup-id "brightnessctl s 1%-; dunstify -h string:x-dunst-stack-tag:brightness --timeout=500 Brightness\ $(brightnessctl -m | cut --delimiter=, -f 4)"
          '';

          #screenshot everything with mod+s, current window with mod+shift+s, selection with mod+ctrl+s
          "${mod}+s" = ''
            exec --no-startup-id "maim ~/Pictures/$(date +%s).png; dunstify --timeout=1000 'Whole-desktop screenshot taken'"
          '';
          "${mod}+shift+s" = ''
            exec --no-startup-id "maim -i $(xdotool getactivewindow) ~/Pictures/$(date +%s).png; dunstify --timeout=1000 'Window screenshot taken'"
          '';
          "${mod}+ctrl+s" = ''
            exec --no-startup-id "maim -s ~/Pictures/$(date +%s).png; dunstify --timeout=1000 'Selection screenshot taken'"
          '';

          #screenshot everything with mod+c, current window with mod+shift+c, selection with mod+ctrl+c (to clipboard)
          "${mod}+c" = ''
            exec --no-startup-id "maim | xclip -selection clipboard -t image/png; dunstify --timeout=1000 'Whole-desktop screenshot taken to clipboard'"
          '';
          "${mod}+shift+c" = ''
            exec --no-startup-id "maim -i $(xdotool getactivewindow) | xclip -selection clipboard -t image/png; dunstify --timeout=1000 'Window screenshot taken to clipboard'"
          '';
          "${mod}+ctrl+c" = ''
            exec --no-startup-id "maim -s | xclip -selection clipboard -t image/png; dunstify --timeout=1000 'Selection screenshot taken to clipboard'"
          '';

          "${mod}+mod1+p" = ''
            exec --no-startup-id "playerctl play-pause"
          '';
          "${mod}+mod1+plus" = ''
            exec --no-startup-id "playerctl volume -- +0.1; dunstify -h string:x-dunst-stack-tag:playervol --timeout=500 Player $(playerctl volume)"
          '';
          "${mod}+mod1+minus" = ''
            exec --no-startup-id "playerctl volume -- -0.1; dunstify -h string:x-dunst-stack-tag:playervol --timeout=500 Player $(playerctl volume)"
          '';

          #open volume control
          "${mod}+shift+p" = ''exec pwvucontrol'';

          #volume control
          "${mod}+plus" = ''
            exec --no-startup-id "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+; dunstify --timeout=1000 -h string:x-dunst-stack-tag:volume -h int:value:$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2 | awk '{print $1*100}' ) Volume"
          '';
          "${mod}+minus" = ''
            exec --no-startup-id "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-; dunstify --timeout=1000 -h string:x-dunst-stack-tag:volume -h int:value:$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2 | awk '{print $1*100}' ) Volume"
          '';

          #open firefox
          "${mod}+w" = ''exec firefox'';
        };
        modes = {
          resize = {
            "Left" = "resize shrink width 10 px or 10 ppt";
            "Down" = "resize grow height 10 px or 10 ppt";
            "Up" = "resize shrink height 10 px or 10 ppt";
            "Right" = "resize grow width 10 px or 10 ppt";
            "Escape" = "mode default";
            "Return" = "mode default";
          };
        };
        gaps = {
          inner = 5;
          smartBorders = "on";
          smartGaps = true;
        };
        fonts = {
          names = ["Fira Code"];
          size = 8.0;
        };
        floating = {
          modifier = mod;
          # you can find window class names with xprop.
          criteria = [
            {class = "pwvucontrol";}
            {class = "helvum";}
          ];
        };
        startup = [
          {
            command = "feh --no-fehbg --bg-fill ~/.background-image";
            notification = false;
            always = true;
          }
        ];
      };
    };
    imports = [
      ../../home-manager/kitty.nix
      ../../home-manager/rofi.nix
      ../../home-manager/dunst.nix
      ../../home-manager/feh.nix
      ../../home-manager/picom.nix
    ];
  };
  imports = [
    ../sound.nix
    ./i3status-rust.nix
    ./lockscreen.nix
  ];
}
