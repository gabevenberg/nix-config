{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  port = "8090";
in {
  services.restic.server = {
    enable = true;
    appendOnly = true;
    dataDir = "/backup/restic";
    extraFlags = [
      "--htpasswd-file ${config.sops.secrets.gabevenberg-draft-credentials.path}"
      "--private-repos"
    ];
    listenAddress = "127.0.0.1:${port}";
  };
  services.nginx.virtualHosts."restic.gabevenberg.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${port}";
    };
  };
}
