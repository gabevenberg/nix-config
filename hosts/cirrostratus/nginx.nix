{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../configs/nixos/nginx.nix
  ];
  #Restic submits some huge requests sometimes.
  services.nginx.clientMaxBodySize = "100m";
}
