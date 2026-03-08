{
  config,
  pkgs,
  lib,
  ...
}: {
  #TODO: use xss-lock
  systemd.services.betterlockscreen = {
    enable = true;
    description = "Locks screen when going to sleep/suspend";
    environment = {DISPLAY = ":0";};
    serviceConfig = {
      User = config.host.details.user;
      Type = "simple";
      ExecStart = ''${lib.getExe pkgs.betterlockscreen} --lock dim'';
      ExecStartPost = ''${pkgs.coreutils}/bin/sleep 1'';
      TimeoutSec = "infinity";
    };
    wantedBy = ["sleep.target"];
    before = ["sleep.target"];
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
