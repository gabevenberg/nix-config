{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.forgejo;
  srv = cfg.settings.server;
in {
  services.forgejo = {
    enable = true;
    database.type = "sqlite3";
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = "git.venberg.xyz";
        ROOT_URL = "https://${srv.DOMAIN}";
        HTTP_PORT = 3000;
        ENABLE_GZIP = true;
      };
      service.DISABLE_REGISTRATION = true;
      ui.DEFAULT_THEME = "forgejo-dark";
      log.LEVEL = "Warn";
      "cron.git_gc_repos".ENABLED = true;
      "cron.resync_all_sshkeys".ENABLED = true;
      "cron.reinit_missing_repos".ENABLED = true;
      "cron.delete_old_actions".ENABLED = true;
      "cron.delete_old_system_notices".ENABLED = true;
      "cron.gc_lfs".ENABLED = true;
    };
  };

  services.nginx.virtualHosts.${srv.DOMAIN} = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString srv.HTTP_PORT}";
    };
  };

  imports = [./nginx.nix];
}
