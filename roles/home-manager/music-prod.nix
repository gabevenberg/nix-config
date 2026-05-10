{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    ardour
    cardinal
    vmpk
    bespokesynth
    surge
    helio-workstation
  ];
}
