{
  config,
  pkgs,
  inputs,
  configLib,
  lib,
  ...
}: {
  services.syncthing = {
    enable = true;
    user = config.host.user;
    group = "users";
    overrideDevices = false;
    overrideFolders = false;
    openDefaultPorts = true;
    systemService = true;
    dataDir="/home/${config.host.user}/Sync";
    configDir="/home/${config.host.user}/.local/state/syncthing";
  };
}
