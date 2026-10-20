# mac counterpart to the i3 config, roughly the same bindings
# option is the modifier.
{
  config,
  lib,
  ...
}: let
  mod = "alt";
  workspaces = map toString (lib.range 1 10);
  key = ws:
    if ws == "10"
    then "0"
    else ws;
in {
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings = {
      gaps = {
        inner.horizontal = 5;
        inner.vertical = 5;
      };
      mode.main.binding =
        {
          "${mod}-enter" = "exec-and-forget open -na ${config.programs.kitty.package}/Applications/kitty.app";
          "${mod}-shift-q" = "close";
          "${mod}-w" = "exec-and-forget open -a Firefox";

          "${mod}-h" = "focus left";
          "${mod}-j" = "focus down";
          "${mod}-k" = "focus up";
          "${mod}-l" = "focus right";

          "${mod}-shift-h" = "move left";
          "${mod}-shift-j" = "move down";
          "${mod}-shift-k" = "move up";
          "${mod}-shift-l" = "move right";

          "${mod}-ctrl-shift-h" = "move-workspace-to-monitor left";
          "${mod}-ctrl-shift-j" = "move-workspace-to-monitor down";
          "${mod}-ctrl-shift-k" = "move-workspace-to-monitor up";
          "${mod}-ctrl-shift-l" = "move-workspace-to-monitor right";

          "${mod}-left" = "focus left";
          "${mod}-down" = "focus down";
          "${mod}-up" = "focus up";
          "${mod}-right" = "focus right";

          "${mod}-shift-left" = "move left";
          "${mod}-shift-down" = "move down";
          "${mod}-shift-up" = "move up";
          "${mod}-shift-right" = "move right";

          "${mod}-ctrl-shift-left" = "move-workspace-to-monitor left";
          "${mod}-ctrl-shift-down" = "move-workspace-to-monitor down";
          "${mod}-ctrl-shift-up" = "move-workspace-to-monitor up";
          "${mod}-ctrl-shift-right" = "move-workspace-to-monitor right";

          "${mod}-f" = "fullscreen";

          "${mod}-e" = "layout accordion vertical";
          "${mod}-r" = "layout accordion horizontal";
          "${mod}-t" = "layout tiles horizontal vertical";

          "${mod}-shift-space" = "layout floating tiling";

          "${mod}-shift-r" = "reload-config";
          "${mod}-ctrl-r" = "mode resize";
        }
        // lib.listToAttrs (map (ws: lib.nameValuePair "${mod}-${key ws}" "workspace ${ws}") workspaces)
        // lib.listToAttrs (map (ws: lib.nameValuePair "${mod}-shift-${key ws}" "move-node-to-workspace ${ws}") workspaces);
      mode.resize.binding = {
        left = "resize width -50";
        down = "resize height +50";
        up = "resize height -50";
        right = "resize width +50";
        esc = "mode main";
        enter = "mode main";
      };
    };
  };
}
