{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    betterlockscreen
  ];
  home-manager.users.${config.host.user} = {
    config,
    osConfig,
    lib,
    ...
  }: {
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
