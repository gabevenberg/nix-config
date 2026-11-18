{...}: {
  services.blocky = {
    enable = true;
    settings = {
      upstreams = {
        groups = {
          default = ["tcp-tls:1.1.1.1:853" "tcp-tls:9.9.9.9:853"];
        };
      };
      dnssec = {
        validate = true;
      };
      blocking = {
        denylists = {
          ads = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
          ];
        };
        clientGroupsBlock = {
          default = ["ads"];
        };
      };
      caching = {
        minTime = "5m";
        maxTime = "30m";
        prefetching = true;
      };
      log = {
        level = "info";
      };
    };
  };
}
