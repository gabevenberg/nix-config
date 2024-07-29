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
  services.nginx.virtualHosts."cal.venberg.xyz" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:5232";
    };
  };
  networking.firewall.allowedTCPPorts = [443 80];
}
