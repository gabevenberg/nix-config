{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  virtualisation.oci-containers = {
    backend = "docker";
    containers.factorio = {
      image = "factoriotools/factorio:stable";
      volumes = ["/storage/factorio:/factorio"];
      hostname = "factorio";
      ports = [
        "34197:34197/udp"
      ];
      environment = {UPDATE_MODS_ON_START = "true";};
    };
  };

  host.restic.backups.factorio = {
    paths = ["/storage/factorio"];
    tags = ["factorio" "games"];
  };

  imports = [
    ./docker.nix
  ];
}
