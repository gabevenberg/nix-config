{
  config,
  lib,
  ...
}: let
  cfg = config.host.niri;
in {
  config = lib.mkIf (cfg.enable && cfg.shell == "noctalia") {
    # noctalia has its own OSD and locks before suspend
    host.niri = {
      startup = lib.mkDefault [["noctalia"]];
      launcherCommand = lib.mkDefault ["noctalia" "msg" "panel-toggle" "launcher"];
      lockCommand = lib.mkDefault ["noctalia" "msg" "session" "lock"];
      volumeUpCommand = lib.mkDefault "noctalia msg volume-up";
      volumeDownCommand = lib.mkDefault "noctalia msg volume-down";
      volumeMuteCommand = lib.mkDefault "noctalia msg volume-mute";
      micMuteCommand = lib.mkDefault "noctalia msg mic-mute";
      brightnessUpCommand = lib.mkDefault "noctalia msg brightness-up";
      brightnessDownCommand = lib.mkDefault "noctalia msg brightness-down";
      playPauseCommand = lib.mkDefault "noctalia msg media toggle";
      stopCommand = lib.mkDefault "noctalia msg media stop";
    };

    # what the nixos programs.noctalia module sets
    xdg.sounds.enable = true;
    services.upower.enable = true;

    home-manager.users.${config.host.details.user} = {config, ...}: {
      # a unit would start under i3 too
      programs.noctalia = {
        enable = true;
        # the gui overrides these in settings.toml
        settings.theme = {
          source = "builtin";
          builtin = "Gruvbox";
          # writes the palette to niri/noctalia.kdl
          templates.builtin_ids = ["niri"];
        };
      };
      # noctalia is the notification daemon
      services.dunst.enable = false;
      user.wallpaper = {
        enable = true;
        updateCommands = ''
          if [ -n "''${NIRI_SOCKET:-}" ]; then
            noctalia msg wallpaper-set ${config.user.wallpaper.path}
            noctalia msg greeter-sync
          fi
        '';
      };
      # last, so the pallet overrides other stuff.
      wayland.windowManager.niri.extraConfig = ''include optional=true "noctalia.kdl"'';
      wayland.windowManager.niri.settings.binds = {
        # the shared titles would say "noctalia"
        "Mod+D"._props.hotkey-overlay-title = lib.mkForce "Run an Application: Noctalia Launcher";
        "Mod+X"._props.hotkey-overlay-title = lib.mkForce "Lock the Screen: Noctalia";
        "Mod+N" = {
          _props.hotkey-overlay-title = "Toggle the Control Center";
          spawn = ["noctalia" "msg" "panel-toggle" "control-center"];
        };
        "Mod+Shift+X" = {
          _props.hotkey-overlay-title = "Open the Session Menu";
          spawn = ["noctalia" "msg" "panel-toggle" "session"];
        };
      };
    };
  };
}
