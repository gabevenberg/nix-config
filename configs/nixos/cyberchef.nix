{pkgs, ...}: {
  services.nginx.virtualHosts."cyberchef.venberg.xyz" = {
    enableACME = true;
    forceSSL = true;
    root = "${pkgs.cyberchef}/share/cyberchef";
  };
}
