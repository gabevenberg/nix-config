{
  config,
  pkgs,
  lib,
  ...
}: {
  services.picom = {
    enable = true;
    backend = "glx";
    extraArgs = ["--transparent-clipping"];
  };
  xsession.windowManager.i3.config.startup = [
    {
      command = "systemctl --user restart picom";
      always = true;
      notification = false;
    }
  ];
}
