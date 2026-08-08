{...}: {
  services.resolved = {
    settings.Resolve = {
      MulticastDNS = true;
    };
  };
  #open firewall for mnds and llmnr.
  networking.firewall.allowedUDPPorts = [5353 5355];
  networking.firewall.allowedTCPPorts = [5355];
}
