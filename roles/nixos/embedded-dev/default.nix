{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  udev-rules = pkgs.stdenv.mkDerivation {
    name = "extra-udev-rules";
    src = ./udev-rules;
    installPhase = ''
      mkdir -p $out/lib/udev/rules.d
      cp *.rules $out/lib/udev/rules.d/
    '';
  };
in {
  imports = [
    ../../../configs/nixos/distrobox.nix
  ];

  services.udev.packages = [udev-rules];

  users.groups.plugdev={};
  users.users.${config.host.details.user}.extraGroups = ["dialout" "plugdev"];

  home-manager.users.${config.host.details.user} = {config, ...}: {
    home.packages = with pkgs; [
      tio
    ];
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      bzip2
      libusb1
      libzip
      openssl
      zstd
    ];
  };
}
