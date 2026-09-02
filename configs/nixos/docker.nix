{...}: {
  virtualisation = {
    containers.registries.settings = {
      unqualified-search-registries = ["docker.io" "quay.io"];
      registry = [
        {location = "docker.io";}
        {location = "quay.io";}
      ];
    };
    podman = {
      enable = true;
      autoPrune.enable = true;
    };
  };
}
