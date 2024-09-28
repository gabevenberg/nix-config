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
  services.nginx.virtualHosts = {
    "gabevenberg.com" = {
      enableACME = true;
      forceSSL = true;
      root = "/var/www/gabevenberg.com";
    };
    "draft.gabevenberg.com" = {
      enableACME = true;
      forceSSL = true;
      root = "/var/www/draft.gabevenberg.com";
      basicAuthFile = config.sops.secrets.gabevenberg-draft-credentials.path;
    };
  };
}
