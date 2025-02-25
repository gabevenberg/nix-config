{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.homepage-dashboard;
  baseurl = "homepage.venberg.xyz";
in {
  services.homepage-dashboard = {
    enable = true;
    settings = {
      theme = "dark";
      color = "slate";
      headerStyle = "boxed";
      base = "https://${baseurl}";
      language = "en";
      hideVersion = true;
      statusStyle = "dot";
      quicklaunch = {
        searchDescriptions = true;
        hideInternetSearch = false;
        hideVisitUrl = false;
        provider = "duckduckgo";
      };
    };

    widgets = [
      {
        datetime = {
          text_size = "x2";
          locale = "en-CA";
          format = {
            hourCycle = "h23";
            hour12 = false;
            year = "numeric";
            month = "numeric";
            day = "numeric";
            hour = "numeric";
            minute = "numeric";
          };
        };
      }
      {
        resources = {
          cpu = true;
          disk = "/";
          memory = true;
        };
      }
      {
        openmeteo = {
          label = "Current";
          units = "metric";
          cache = 5;
        };
      }
      {
        openmeteo = {
          label = "Mainz";
          timezone = "Europe/Berlin";
          units = "metric";
          cache = 5;
          latitude = 49.999444;
          longitude = 8.273611;
        };
      }
    ];

    services = [
      {
        Family = [
          {
            Jellyfin = {
              icon = "sh-jellyfin.svg";
              href = "https://media.venberg.xyz";
              siteMonitor = "https://media.venberg.xyz";
              description = "Movies";
            };
          }
          {
            Grocy = {
              icon = "sh-grocy.svg";
              href = "https://grocy.venberg.xyz";
              siteMonitor = "https://grocy.venberg.xyz";
              description = "Family ERP";
            };
          }
          {
            Radicale = {
              icon = "sh-radicale.svg";
              href = "https://cal.venberg.xyz";
              siteMonitor = "https://cal.venberg.xyz";
              description = "Calander administration";
            };
          }
          {
            Syncthing = {
              icon = "sh-syncthing.svg";
              href = "http://localhost:8384";
              description = "Local Syncthing dashboard";
            };
          }
        ];
      }
      {
        Development = [
          {
            Forgejo = {
              icon = "sh-forgejo.svg";
              href = "https://git.venberg.xyz";
              siteMonitor = "https://git.venberg.xyz";
              description = "Self hosted Git forge.";
            };
          }
          {
            Github = {
              icon = "si-github-#181717";
              href = "https://github.com";
              siteMonitor = "https://git.venberg.xyz";
              description = "Non self hosted Git forge :(";
            };
          }
          {
            Cyberchef = {
              icon = "sh-cyberchef.svg";
              href = "https://cyberchef.venberg.xyz";
              siteMonitor = "https://cyberchef.venberg.xyz";
              description = "a data toolbox";
            };
          }
        ];
      }
    ];
  };

  services.nginx.virtualHosts.${baseurl} = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString cfg.listenPort}";
    };
  };
}
