{
  config,
  pkgs,
  lib,
  ...
}: {
  services = {
    dunst.enable = true;
    dunst.settings = {
      global = {
        font = "Fira Code";
        follow = "keyboard";
        origin = "top-right";
        transparency = 20;
        padding = 6;
        horizontal_padding = 6;
      };
      urgency_low = {
        # IMPORTANT: colors have to be defined in quotation marks.
        # Otherwise the "#" and following would be interpreted as a comment.
        frame_color = "#3B7C87";
        foreground = "#3B7C87";
        highlight = "#3B7C87";
        background = "#191311";
        #background = "#2B313C"
        timeout = 4;
        # Icon for notifications with low urgency, uncomment to enable
        #default_icon = /path/to/icon
      };

      urgency_normal = {
        frame_color = "#5B8234";
        foreground = "#5B8234";
        highlight = "#5B8234";
        background = "#191311";
        #background = "#2B313C"
        timeout = 6;
        # Icon for notifications with normal urgency, uncomment to enable
        #default_icon = /path/to/icon
      };

      urgency_critical = {
        frame_color = "#B7472A";
        foreground = "#B7472A";
        highlight = "#B7472A";
        background = "#191311";
        #background = "#2B313C"
        timeout = 8;
        # Icon for notifications with critical urgency, uncomment to enable
        #default_icon = /path/to/icon
      };
    };
  };
}
