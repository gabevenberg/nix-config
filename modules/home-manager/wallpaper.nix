{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.user.wallpaper;
in {
  options = {
    user.wallpaper = {
      enable = lib.mkEnableOption "set-wallpaper script, changes wallpaper for every enabled window manager";
      path = lib.mkOption {
        type = lib.types.str;
        default = "${config.xdg.dataHome}/wallpaper";
        readOnly = true;
        description = "where set-wallpaper copies the image, for window managers to read on startup";
      };
      updateCommands = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "shell run by set-wallpaper after copying, for each installed window manager to pick up the new image";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.writeShellScriptBin "set-wallpaper" ''
        set -euo pipefail
        mkdir -p "$(dirname ${cfg.path})"
        cp -- "$1" ${cfg.path}
        ${cfg.updateCommands}
      '')
    ];
  };
}
