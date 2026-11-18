{lib, ...}: {
  options = {
    host.details = {
      user = lib.mkOption {
        type = lib.types.str;
        description = "Primary human user";
      };
      fullName = lib.mkOption {
        type = lib.types.str;
        description = "Primary human users long name";
      };
      gui.enable = lib.mkEnableOption "enable GUI";
      isLaptop = lib.mkEnableOption "machine is a laptop";
      isVm = lib.mkEnableOption "machine is a virtual machine";
      isSever = lib.mkEnableOption "machine is primarily a server";
      lockdown = {
        enable = lib.mkEnableOption "close all inbound firewall ports except 22 on non-tailscale interfaces";
        extraAllowedTCPPorts = lib.mkOption {
          type = lib.types.listOf lib.types.port;
          default = [];
          description = "TCP ports that stay open on non-tailscale interfaces even during lockdown";
        };
        extraAllowedUDPPorts = lib.mkOption {
          type = lib.types.listOf lib.types.port;
          default = [];
          description = "UDP ports that stay open on non-tailscale interfaces even during lockdown";
        };
      };
    };
  };
}
