{
  config,
  pkgs,
  lib,
  ...
}: {
  systemd.services.betterlockscreen = {
    enable = true;
    description = "Locks screen when going to sleep/suspend";
    environment = {DISPLAY = "0";};
    serviceConfig = {
      User = config.host.details.user;
      alias = ["betterlockscreen@${config.host.details.user}.service"];
      Type = "simple";
      ExecStart = ''${pkgs.betterlockscreen}/bin/betterlockscreen --lock dim'';
      TimeoutSec = "infinity";
    };
    wantedBy = ["sleep.target" "suspend.target"];
  };

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
    # Define systemd service for betterlockscreen to run on suspend
    imports = [
      ../../home-manager/feh.nix
    ];
  };
}
