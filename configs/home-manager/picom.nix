{
  config,
  pkgs,
  lib,
  ...
}: {
  services.picom = {
    enable = true;
    # backend = "glx";
  };
  xsession.windowManager.i3.config.startup = [
    {
      command = "systemctl --user restart picom";
      always = true;
      notification = false;
    }
  ];
}
