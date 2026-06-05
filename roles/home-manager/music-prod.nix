{pkgs, ...}: {
  home.packages = with pkgs; [
    ardour
    cardinal
    vmpk
    bespokesynth
    surge-xt
    helio-workstation
  ];
}
