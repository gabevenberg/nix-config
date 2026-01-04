{
  config,
  pkgs,
  lib,
  ...
}: {
  # when it gets packaged, will want cadquery and build123d
  home.packages = with pkgs; [
  ardour
  cardinal
  vmpk
  bespokesynth
  surge
  helio-workstation
  ];
}
