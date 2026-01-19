{
  config,
  pkgs,
  lib,
  ...
}: {
  services.shpool = {
    enable = true;
    settings = {
      default_dir = ".";
      prompt_prefix = "";
      keybinding = [
        {
          action = "detach";
          binding = "Ctrl-a d";
        }
      ];
    };
    systemd = true;
  };
}
