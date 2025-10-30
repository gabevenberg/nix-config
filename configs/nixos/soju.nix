{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  domain = "irc.venberg.xyz";
  port = 6697;
  certDir = config.security.acme.certs.${domain}.directory;
in {
  security.acme.certs.${domain} = {
    reloadServices = ["soju.service"];
    group = config.services.nginx.group;
  };
  # webserver for http challenge
  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    useACMEHost = domain;
    locations."/.well-known/".root = "/var/lib/acme/acme-challenge/";
  };
  networking.firewall.allowedTCPPorts = [port 80];
  services.soju = {
    enable = true;
    hostName = domain;
    listen = [":${builtins.toString port}"];
    tlsCertificate = "/run/credentials/soju.service/cert.pem";
    tlsCertificateKey = "/run/credentials/soju.service/key.pem";
    enableMessageLogging = true;
  };
  systemd.services.soju.serviceConfig.LoadCredential = [
    "cert.pem:${certDir}/cert.pem"
    "key.pem:${certDir}/key.pem"
  ];
}
