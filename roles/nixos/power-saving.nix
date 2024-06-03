{
  config,
  pkgs,
  lib,
  ...
}: {
  powerManagement.powertop.enable = true;
  powerManagement.enable = true;
  powerManaagement.cpuFreqGovernor = "ondemand";
}
