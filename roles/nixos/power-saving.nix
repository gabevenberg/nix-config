{
  config,
  lib,
  ...
}: let
  enable = !config.services.power-profiles-daemon.enable;
in {
  powerManagement.enable = true;
  powerManagement.powertop.enable = enable;
  powerManagement.cpuFreqGovernor = lib.mkIf enable "ondemand";
}
