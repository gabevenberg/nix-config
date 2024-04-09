{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    host = {
      user = lib.mkOption {
        type = lib.types.str;
        description = "Primary human user";
      };
      fullName = lib.mkOption {
        type = lib.types.str;
        description = "Primary human users long name";
      };
      gui.enable = lib.mkEnableOption {
        description = "enable GUI";
        default = false;
      };
      isLaptop=lib.mkEnableOption {
        description="machine is a laptop";
        default=false;
      };
      isVm=lib.mkEnableOption {
        description="machine is a virtual machine";
        default=false;
      };
    };
  };
}
