{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.duckdns;
  urlFile = pkgs.writeText "curlurl" "url=https://www.duckdns.org/update?domains=@domains_placeholder@&token=@token_placeholder@&ip=";
in {
  # partially taken from https://github.com/NixOS/nixpkgs/pull/294489
  options = {
    services.duckdns = {
      enable = lib.mkEnableOption "Enable duckdns updating";
      tokenFile = lib.mkOption {
        default = null;
        type = lib.types.path;
        description = ''
          The path to a file containing the token
          used to authenticate with DuckDNS.
        '';
      };
      domains = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.str);
        example = ["examplehost"];
        description = lib.mdDoc ''
          The record(s) to update in DuckDNS
          (without the .duckdns.org prefix)
        '';
      };
      domainsFile = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.path;
        description = ''
          The path to a file containing a
          newline-separated list of DuckDNS
          domain(s) to be updated
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.domains != null || cfg.domainsFile != null;
        message = "services.duckdns.domains or services.duckdns.domainsFile has to be defined";
      }
    ];
    systemd.services.duckdns = {
      description = "DuckDNS Dynamic DNS Client";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      # every 5 minutes
      startAt = "*:00/5:00";
      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        RuntimeDirectory = "duckdns-update";
        RuntimeDirectoryMode = "700";
        LoadCredential =
          [
            "tokenFile:${cfg.tokenFile}"
          ]
          ++ lib.optionals (cfg.domainsFile != null) ["domainsFile:${cfg.domainsFile}"];
      };
      script = ''
        install --mode 600 ${urlFile} $RUNTIME_DIRECTORY/curlurl
        # replace the token
        ${pkgs.replace-secret}/bin/replace-secret @token_placeholder@ $CREDENTIALS_DIRECTORY/tokenFile $RUNTIME_DIRECTORY/curlurl

        # initalise the replacement file for the domains from the domains file if it exists, otherwise make it empty.
        install --mode 600 ${
          if (cfg.domainsFile != null)
          then "$CREDENTIALS_DIRECTORY/domainsFile"
          else "/dev/null"
        } $RUNTIME_DIRECTORY/domains
        # these are already in the nix store, so doesnt matter if they leak via cmdline.
        echo '${lib.strings.concatStringsSep "\n" cfg.domains}' >>  $RUNTIME_DIRECTORY/domains
        ${pkgs.gnused}/bin/sed -zi 's/\n/,/g' $RUNTIME_DIRECTORY/domains
        ${pkgs.replace-secret}/bin/replace-secret @domains_placeholder@ $RUNTIME_DIRECTORY/domains $RUNTIME_DIRECTORY/curlurl

        ${pkgs.curl}/bin/curl --no-progress-meter --insecure --config $RUNTIME_DIRECTORY/curlurl | ${pkgs.gnugrep}/bin/grep -v "KO"
      '';
    };
  };
}
