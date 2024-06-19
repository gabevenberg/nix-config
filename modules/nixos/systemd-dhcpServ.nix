{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options = {
    host.systemdDhcpSrv = {
      enable = lib.mkEnableOption "systemd DHCP server";

      interface = lib.mkOption {
        type = lib.types.str;
        description = "interface to run dhcp server on";
      };

      uplinkInterface = lib.mkOption {
        type = lib.types.str;
        description = "if dns, router, or ntp are set but no adresses are set, pass on the settings of this interface.";
        default = ":auto";
      };

      pool = lib.mkOption {
        description = "the pool of ips the dhcp server will hand out.";
        type = lib.types.submodule {
          options = {
            start = lib.mkOption {
              type = lib.types.str;
              description = "starting IP of the range the dhcp server will assign";
            };
            end = lib.mkOption {
              type = lib.types.str;
              description = "ending IP of the range the dhcp server will assign";
            };
          };
        };
      };

      time = lib.mkOption {
        type = lib.types.submodule {
          options = {
            default = lib.mkOption {
              description = "the default dhcp lease time, in seconds, defaults to 1h";
              type = lib.types.nullOr lib.types.int;
              default = null;
            };
            max = lib.mkOption {
              description = "the max dhcp lease time, in seconds. defaults to 12h";
              type = lib.types.nullOr lib.types.int;
              default = null;
            };
          };
        };
      };

      dns = lib.mkoption {
        type = lib.types.submodule {
          options = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "whether to include dns server info in the dhcp lease";
            };
            servers = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              description = "IPs of dns servers to hand out";
              default = [];
            };
          };
        };
      };

      router = lib.mkoption {
        type = lib.types.submodule {
          options = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "whether to include router (gateway) info in the dhcp lease";
            };
            servers = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              description = "IPs of dns servers to hand out";
              default = [];
            };
          };
        };
      };

      ntp = lib.mkoption {
        type = lib.types.submodule {
          options = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "whether to include ntp server info in the dhcp lease";
            };
            servers = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              description = "IPs of ntp servers to hand out";
              default = [];
            };
          };
        };
      };
    };
  };
}
