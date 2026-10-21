{lib, ...}: {
  options = {
    user.theme = {
      noctalia = lib.mkEnableOption "read app colours from noctalia instead of the default";
      targets = lib.mkOption {
        default = {};
        description = "files noctalia renders an app's colours into";
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            template = lib.mkOption {
              type = lib.types.either lib.types.path lib.types.str;
              description = "noctalia template the file is rendered from";
            };
            path = lib.mkOption {
              type = lib.types.str;
              description = "where the app reads the file, relative to home";
            };
            reload = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "shell run after noctalia renders the file";
            };
            postAction = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "noctalia native action run after the file is rendered";
            };
          };
        });
      };
    };
  };
}
