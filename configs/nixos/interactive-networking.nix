{config, ...}: {
  # Enable networking
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };
  services.resolved = {
    enable = true;
    settings.Resolve = {
      MulticastDNS = true;
    };
  };
  networking.firewall.allowedUDPPorts = [5353 5355];
  networking.firewall.allowedTCPPorts = [5355];
  users.users.${config.host.details.user}.extraGroups = ["networkmanager"];

  imports = [./mdns.nix];
}
