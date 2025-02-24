{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  virtualisation.docker.enable = true;
  users.users.${config.host.user}.extraGroups = ["docker"];
}
