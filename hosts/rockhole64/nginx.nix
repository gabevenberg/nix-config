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

  # For non-nix home assistant.
  services.nginx.virtualHosts."home.venberg.xyz" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://10.10.0.3:8123";
      proxyWebsockets = true;
    };
  };
}
