{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.host.greeter;
  # set-wallpaper mirrors the image somewhere the greeter can read
  regreetWallpaper = "/var/lib/greeter-wallpaper/wallpaper";
in {
  options.host.greeter = lib.mkOption {
    type = lib.types.enum ["regreet" "tuigreet" "noctalia" "ly" "none"];
    default = "none";
    description = "display manager to run";
  };

  config = lib.mkIf config.host.details.gui.enable (lib.mkMerge [
    (lib.mkIf (builtins.elem cfg ["regreet" "tuigreet" "noctalia"]) {
      services.greetd.enable = true;
    })
    (lib.mkIf (cfg == "regreet") {
      services.displayManager.regreet = {
        enable = true;
        theme.name = "Adwaita-dark";
        settings = {
          background = {
            path = regreetWallpaper;
            fit = "Cover";
          };
          commands = lib.mkIf config.services.xserver.displayManager.startx.enable {
            x11_prefix = [
              (lib.getExe' pkgs.xinit "startx")
              (lib.getExe' pkgs.coreutils "env")
            ];
          };
        };
      };
      systemd.tmpfiles.rules = [
        "d ${dirOf regreetWallpaper} 0755 ${config.host.details.user} - -"
      ];
      home-manager.users.${config.host.details.user} = {config, ...}: {
        user.wallpaper.updateCommands = ''
          cp --reflink=auto -- ${config.user.wallpaper.path} ${regreetWallpaper}
        '';
      };
    })
    (lib.mkIf (cfg == "tuigreet") {
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
    })
    (lib.mkIf (cfg == "noctalia") {
      services.displayManager.noctalia-greeter = {
        enable = true;
        passwordlessSyncUsers = [config.host.details.user];
        cursorTheme = {
          package = pkgs.phinger-cursors;
          name = "phinger-cursors-dark";
        };
      };
      # so it finds the sessions, the nixpkgs module doesn't
      services.greetd.settings.default_session.command = let
        greeter = config.services.displayManager.noctalia-greeter;
      in
        lib.escapeShellArgs ([
            (lib.getExe' pkgs.coreutils "env")
            "XDG_DATA_DIRS=${config.services.displayManager.sessionData.desktops}/share"
            (lib.getExe' greeter.package "noctalia-greeter-session")
          ]
          ++ greeter.extraArgs);
    })
    (lib.mkIf (cfg == "ly") {
      services.displayManager.ly = {
        enable = true;
        settings = {
          animation = "matrix";
          bigclock = "en";
        };
      };
    })
  ]);
}
