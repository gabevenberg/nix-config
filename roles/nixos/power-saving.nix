{
  config,
  pkgs,
  lib,
  ...
}: {
  powerManagement.powertop.enable = true;
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";
}
