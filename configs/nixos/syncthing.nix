{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  services.syncthing = {
    enable = true;
    user = config.host.details.user;
    group = "users";
    overrideDevices = false;
    overrideFolders = false;
    openDefaultPorts = true;
    systemService = true;
    dataDir = "/home/${config.host.details.user}/Sync";
    configDir = "/home/${config.host.details.user}/.local/state/syncthing";
  };
}
