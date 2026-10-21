{...}: {
  services.adguardhome = {
    enable = true;
    mutableSettings = true;
    allowDHCP = true;
    openFirewall = true;
    settings.http.address = "0.0.0.0:8080";
  };
  networking.firewall.allowedUDPPorts = [53 67 546 547];
}
