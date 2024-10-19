{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      userland-proxy = false;
    };
  };
  users.users.${config.host.user}.extraGroups = ["docker"];
}
