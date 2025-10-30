{
  config,
  pkgs,
  lib,
  ...
}: {
  console.useXkbConfig = true;
  fonts.fontDir.enable = true;
  fonts.enableDefaultPackages = true;
  services.xserver.xkb.options = "ctrl:nocaps,compose:rctrl";
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      bigclock = "en";
    };
  };
}
