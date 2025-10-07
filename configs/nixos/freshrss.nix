{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.freshrss;
in {
  services.freshrss={
    enable=true;
    database.type="sqlite";
    webserver="nginx";
    baseUrl="https://rss.venberg.xyz";
    virtualHost = "rss.venberg.xyz";
    passwordFile = config.sops.secrets.freshrss-password.path;
    defaultUser="gabe";
  };

  services.nginx.virtualHosts.${cfg.virtualHost}= {
    enableACME = true;
    forceSSL = true;
  };
  # host.restic.backups.freshrss = {
  #   paths = [
  #   TODO
  #   ];
  #   preBackupCommands = "TODO";
  #   postBackupCommands = "TODO";
  # };

  imports = [./nginx.nix];
}
