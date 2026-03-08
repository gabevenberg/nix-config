{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.homebox;
in {
  services.homebox = {
    enable = true;
    settings = {
      HBOX_OPTIONS_TRUST_PROXY = "true";
      HBOX_OPTIONS_HOSTNAME = "inventory.venberg.xyz";
      HBOX_OPTIONS_CHECK_GITHUB_RELEASE = "false";
      HBOX_OPTIONS_ALLOW_REGISTRATION = "false";
      HBOX_MODE = "production";
    };
  };

  services.nginx.virtualHosts.${cfg.settings.HBOX_OPTIONS_HOSTNAME} = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:7745";
      proxyWebsockets = true;
    };
  };
}
