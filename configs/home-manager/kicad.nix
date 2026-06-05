{pkgs, ...}: {
  home.packages = with pkgs; [
    (kicad.override {compressStep = false;})
    interactive-html-bom
  ];
}
