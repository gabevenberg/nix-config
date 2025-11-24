{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  # nixpkgs.config = lib.mkIf (inputs ? nixpkgs-fork) {
  #   kicad = {compressStep = false;};
  # };
  nixpkgs.overlays = [
    (final: prev: {kicad = inputs.nixpkgs-fork.legacyPackages.${prev.system}.kicad.override {compressStep = false;};})
  ];
  home-manager.users.${config.host.details.user} = {config, ...}: {
    home.packages = with pkgs; [
      kicad
      interactive-html-bom
    ];
  };
}
