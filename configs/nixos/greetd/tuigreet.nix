{
  config,
  lib,
  pkgs,
  ...
}: {
  services.greetd = {
    useTextGreeter = true;
    settings.default_session.command = let
      sessions = config.services.displayManager.sessionData.desktops;
    in
      lib.escapeShellArgs ([
          (lib.getExe pkgs.tuigreet)
          "--time"
          "--asterisks"
          "--remember"
          "--remember-user-session"
          "--sessions"
          "${sessions}/share/wayland-sessions"
        ]
        ++ lib.optionals config.services.xserver.displayManager.startx.enable [
          "--xsessions"
          "${sessions}/share/xsessions"
          "--xsession-wrapper"
          "${lib.getExe' pkgs.xinit "startx"} ${lib.getExe' pkgs.coreutils "env"}"
        ]);
  };
  imports = [
    ./common.nix
  ];
}
