{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    gnutar
    zip
    unzip
    p7zip
    gzip
    xz
    zstd
    ouch
  ];
}
