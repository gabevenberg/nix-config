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
}
