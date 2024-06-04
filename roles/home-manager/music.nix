{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../configs/home-manager/beets.nix
    ../../configs/home-manager/mpd.nix
  ];
  home.packages = with pkgs; (lib.mkIf config.host.gui.enable [
    mpdevil
  ]);
}
