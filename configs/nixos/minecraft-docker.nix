{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
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
        PACKWIZ_URL = "https://static.venberg.xyz/minecraft/less-than-compact-2/pack.toml";
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
        OPS = ''
          TheToric
        '';
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
  imports = [
    ./docker.nix
  ];
}
