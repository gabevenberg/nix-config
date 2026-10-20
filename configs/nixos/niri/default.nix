{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  xdg.portal = {
    extraPortals = [pkgs.xdg-desktop-portal-termfilechooser];
    config.niri."org.freedesktop.impl.portal.FileChooser" = lib.mkForce "termfilechooser";
  };

  home-manager.users.${config.host.details.user} = {...}: {
    wayland.windowManager.niri = {
      enable = true;
      # the niri nixos module already ships systemd units.
      systemd.enable = false;
      portalPackage = null;
      enableDefaultConfig = true;
      settings = {
        input.keyboard.xkb.options = config.services.xserver.xkb.options;
        binds."Mod+Return".spawn = ["kitty"];
      };
    };
    xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
      [filechooser]
      cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
      default_dir=$HOME
      open_mode=suggested
      save_mode=suggested
    '';
  };
  imports = [
    ../graphical.nix
  ];
}
