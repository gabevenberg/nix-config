{
  config,
  pkgs,
  ...
}: {
  # Enable networking
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };
  services.resolved.enable = true;
  users.users.${config.host.details.user}.extraGroups = ["networkmanager"];
}
