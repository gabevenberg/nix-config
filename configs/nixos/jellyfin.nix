{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./nginx.nix
  ];
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    dataDir = "/storage/jellyfin";
  };
  services.nginx.virtualHosts."media.venberg.xyz" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:8096";
    };
  };
}
