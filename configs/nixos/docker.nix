{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  users.users.${config.host.details.user}.extraGroups = ["docker"];
}
