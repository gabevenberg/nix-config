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

  #allow us to manage jellyfins media.
  users.users.${config.host.details.user}.extraGroups = ["jellyfin"];

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
    locations."/socket" = {
      proxyPass = "http://localhost:8096";
      proxyWebsockets = true;
    };
  };
}
