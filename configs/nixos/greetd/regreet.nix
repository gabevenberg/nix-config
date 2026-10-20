{
  config,
  lib,
  pkgs,
  ...
}: {
  services.displayManager.regreet = {
    enable = true;
    theme.name = "Adwaita-dark";
    settings.commands = lib.mkIf config.services.xserver.displayManager.startx.enable {
      x11_prefix = [
        (lib.getExe' pkgs.xinit "startx")
        (lib.getExe' pkgs.coreutils "env")
      ];
    };
  };
  imports = [
    ./common.nix
  ];
}
