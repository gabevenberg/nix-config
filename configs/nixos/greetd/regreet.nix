{
  config,
  lib,
  pkgs,
  ...
}: let
  # home is 0700, so set-wallpaper mirrors the image somewhere the greeter user can read
  wallpaper = "/var/lib/greeter-wallpaper/wallpaper";
in {
  services.displayManager.regreet = {
    enable = true;
    theme.name = "Adwaita-dark";
    settings = {
      background = {
        path = wallpaper;
        fit = "Cover";
      };
      commands = lib.mkIf config.services.xserver.displayManager.startx.enable {
        x11_prefix = [
          (lib.getExe' pkgs.xinit "startx")
          (lib.getExe' pkgs.coreutils "env")
        ];
      };
    };
  };
  systemd.tmpfiles.rules = [
    "d ${dirOf wallpaper} 0755 ${config.host.details.user} - -"
  ];
  home-manager.users.${config.host.details.user} = {config, ...}: {
    user.wallpaper.updateCommands = ''
      cp --reflink=auto -- ${config.user.wallpaper.path} ${wallpaper}
    '';
  };
  imports = [
    ./common.nix
  ];
}
