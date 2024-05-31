{
  config,
  pkgs,
  ...
}: {
  # Enable networking
  networking.networkmanager.enable = true;
  users.users.${config.host.user}.extraGroups = ["networkmanager"];
}
