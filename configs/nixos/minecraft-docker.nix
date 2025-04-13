{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  preBackup = pkgs.writeShellScriptBin "mc-docker-pre-backup" ''
    set -euxo pipefail

    docker exec minecraft rcon-cli "say server backing up, expect minor lag"
    sleep 10
    docker exec minecraft rcon-cli "save-all flush"
    docker exec minecraft rcon-cli "save-off"
    sleep 10
  '';
  postBackup = pkgs.writeShellScriptBin "mc-docker-post-backup" ''
    set -euxo pipefail

    docker exec minecraft rcon-cli "save-on"
    docker exec minecraft rcon-cli "say server backup succsessful!"
  '';
in {
  virtualisation.oci-containers = {
    backend = "docker";
    containers.minecraft = {
      image = "itzg/minecraft-server";
      volumes = ["/storage/minecraft:/data"];
      hostname = "minecraft";
      ports = [
        "25565:25565"
      ];
      environment = {
        EULA = "TRUE";
        TYPE = "FORGE";
        VERSION = "1.20.1";
        # REMOVE_OLD_MODS="TRUE";
        # PACKWIZ_URL = "https://static.venberg.xyz/minecraft/less-than-compact-2/pack.toml";
        MEMORY = "16G";
        USE_AIKAR_FLAGS = "true";
        UID = "1000";
        GID = "100";
        STOP_SERVER_ANNOUNCE_DELAY = "30";
        ENABLE_ROLLING_LOGS = "true";
        GUI = "FALSE";
        # SETUP_ONLY = "true";
        MOTD = "Welcome!";
        DIFFICULTY = "normal";
        OPS = "TheToric";
        ENFORCE_WHITELIST = "true";
        ENABLE_WHITELIST = "true";
        ANNOUNCE_PLAYER_ACHIEVEMENTS = "true";
        ALLOW_FLIGHT = "TRUE";
        ENABLE_AUTOPAUSE = "true";
        MAX_TICK_TIME = "-1";
      };
      extraOptions = ["--stop-timeout=60"];
    };
  };

  host.restic.backups.minecraft = {
    preBackupCommands = "${preBackup}/bin/mc-docker-pre-backup";
    postBackupCommands = "${postBackup}/bin/mc-docker-post-backup";
    paths = ["/storage/minecraft"];
  };

  imports = [
    ./docker.nix
  ];
}
