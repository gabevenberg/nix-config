{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  port = 2283;
  cfg = config.services.immich;
  backupPrepare = pkgs.writeShellScriptBin "postgres-immich-dump" ''
    set -euxo pipefail
    ${lib.getExe pkgs.sudo} -iu postgres pg_dump -Fc immich > /backup/immich_psql.dump
  '';
in {
  # make sure your postgres database is on big storage, and if using zfs, create with the following settings:
  # zfs create -o recordsize=8K -o primarycache=metadata -o mountpoint=/var/lib/postgresql <pool>/postgresql
  services.immich = {
    enable = true;
    port = port;
    machine-learning.enable = true;
    mediaLocation = "/storage/immich";
    settings = null;
  };
  imports = [
    ./nginx.nix
  ];
  services.nginx.virtualHosts."pics.venberg.xyz" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString port}";
    };
  };
  host.restic.backups.immich = {
    preBackupCommands = lib.getExe backupPrepare;
    paths = [
      "/backup/immich_psql.dump"
      "${cfg.mediaLocation}/library"
      "${cfg.mediaLocation}/upload"
      "${cfg.mediaLocation}/profile"
    ];
  };
}
