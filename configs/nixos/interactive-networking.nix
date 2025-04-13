{
  config,
  pkgs,
  ...
}: {
  # Enable networking
  networking.networkmanager.enable = true;
  users.users.${config.host.details.user}.extraGroups = ["networkmanager"];
}
