{
  config,
  pkgs,
  lib,
  ...
}: {
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
    };
  };
}
