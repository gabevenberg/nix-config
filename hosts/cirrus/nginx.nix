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
  services.nginx.virtualHosts."gabevenberg.com" = {
    enableACME = true;
    forceSSL = true;
    root = "/var/www/gabevenberg.com";
  };
}
