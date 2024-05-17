{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../modules/home-manager/beets.nix
    ../../modules/home-manager/mpd.nix
    ../../modules/home-manager/beets.nix
  ];
  home.packages = with pkgs; (lib.mkIf config.host.gui.enable [
    mpdevil
  ]);
}
