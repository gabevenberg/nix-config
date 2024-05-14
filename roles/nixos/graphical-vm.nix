{
  config,
  pkgs,
  lib,
  ...
}: {
  #note: needs to have something that autostarts desktop files.
  services.spice-vdagentd.enable = true;
  services.spice-autorandr.enable=true;
  imports = [
    ./vm.nix
  ];
  host.gui.enable = true;
}
