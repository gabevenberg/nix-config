{...}: {
  services.resolved = {
    settings.Resolve = {
      MulticastDNS = true;
    };
  };
  #open firewall for mnds and llmnr.
  networking.firewall.allowedUDPPorts = [5353 5355];
  networking.firewall.allowedTCPPorts = [5355];
  # keep .local resolution working during lockdown
  host.details.lockdown.extraAllowedUDPPorts = [5353 5355];
  host.details.lockdown.extraAllowedTCPPorts = [5355];
}
