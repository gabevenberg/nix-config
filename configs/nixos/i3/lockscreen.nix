{
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager.users.${config.host.details.user} = {
    config,
    osConfig,
    lib,
    ...
  }: {
    home.packages = with pkgs; [
      betterlockscreen
    ];

    xsession.windowManager.i3.config = {
      keybindings = let
        mod = config.xsession.windowManager.i3.config.modifier;
      in {
        "${mod}+x" = ''
          exec --no-startup-id betterlockscreen --lock blur
        '';
      };
    };
    imports = [
      ../../home-manager/feh.nix
    ];
  };
}
