{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  services.nginx.virtualHosts."static.venberg.xyz" = {
    enableACME = true;
    forceSSL = true;
    root = "/storage/static";
  };
}
