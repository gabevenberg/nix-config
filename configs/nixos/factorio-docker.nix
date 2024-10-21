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
        "34197:34197"
        "27015:27015"
      ];
      environment={
        UPDATE_MODS_ON_START="true";
      };
    };
  };
  imports = [
    ./docker.nix
  ];
}