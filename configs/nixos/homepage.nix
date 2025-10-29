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
    allowedHosts = baseurl;
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
          label = "Wiesbaden";
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
            Immich = {
              icon = "sh-immich.svg";
              href = "https://pics.venberg.xyz";
              siteMonitor = "https://pics.venberg.xyz";
              description = "Pictures";
            };
          }
          {
            HomeAssistant = {
              icon = "sh-home-assistant.svg";
              href = "https://home.venberg.xyz";
              siteMonitor = "https://home.venberg.xyz";
              description = "Home Automation";
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
            CopyParty = {
              icon = "sh-copyparty.svg";
              href = "https://files.venberg.xyz";
              siteMonitor = "https://files.venberg.xyz";
              description = "Online file browser";
            };
          }
          {
            FreshRSS = {
              icon = "sh-freshrss.svg";
              href = "https://rss.venberg.xyz";
              siteMonitor = "https://rss.venberg.xyz";
              description = "Feed reader";
            };
          }
        ];
      }
      {
        Internal = [
          {
            FritzBox = {
              icon = "sh-fritz.svg";
              href = "http://10.10.0.1";
              description = "Router";
            };
          }
          {
            AdGuardHome = {
              icon = "sh-adguard-home.svg";
              href = "http://10.10.0.2:8080";
              description = "Home Automation";
            };
          }
          {
            Deluge = {
              icon = "sh-deluge.svg";
              href = "http:cirrostratus:8112";
              siteMonitor = "http:cirrostratus:8112";
              description = "Torrent webUI";
            };
          }
          # {
          #   Transmission = {
          #     icon = "sh-transmission.svg";
          #     href = "http:cirrostratus:9091";
          #     siteMonitor = "http:cirrostratus:9091";
          #     description = "Torrent webUI";
          #   };
          # }
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
              siteMonitor = "https://github.com";
              description = "Non self hosted Git forge :(";
            };
          }
          {
            Codeberg = {
              icon = "sh-codeberg";
              href = "https://codeberg.org";
              siteMonitor = "https://codeberg.org";
              description = "Non self hosted Git forge, but at least open source!";
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
