{...}: let
  seerport = 52342;
in {
  services.flaresolverr = {
    enable = true;
    port = 8191;
  };
  services.prowlarr = {
    enable = true;
    openFirewall = false;
    settings.auth.required = "DisabledForLocalAddresses";
    settings.server.port = 9696;
  };
  services.sonarr = {
    enable = true;
    user = "jellyfin";
    group = "jellyfin";
    openFirewall = false;
    settings.auth.required = "DisabledForLocalAddresses";
    settings.server.port = 8989;
  };
  services.radarr = {
    enable = true;
    user = "jellyfin";
    group = "jellyfin";
    openFirewall = false;
    settings.auth.required = "DisabledForLocalAddresses";
    settings.server.port = 7878;
  };
  services.lidarr = {
    enable = true;
    user = "jellyfin";
    group = "jellyfin";
    openFirewall = false;
    settings.auth.required = "DisabledForLocalAddresses";
    settings.server.port = 8686;
  };
  services.bazarr = {
    enable = true;
    user = "jellyfin";
    group = "jellyfin";
    openFirewall = false;
    listenPort = 6767;
  };
  services.seerr = {
    enable = true;
    port = seerport;
  };
  services.nginx.virtualHosts."mediarequests.venberg.xyz" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString seerport}";
    };
  };
}
