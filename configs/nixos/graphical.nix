{config, ...}: {
  console.useXkbConfig = true;
  fonts.fontDir.enable = true;
  fonts.enableDefaultPackages = true;
  services.xserver.xkb.options = "ctrl:nocaps,compose:rctrl";
  services.libinput = {
    mouse.middleEmulation = false;
    touchpad.middleEmulation = false;
  };
  services.accounts-daemon.enable = true;
  nixpkgs.config.zathura.useMupdf = true;
  programs.dconf.enable = true;
  programs.firefox.enable = true;

  home-manager.users.${config.host.details.user} = {
    config,
    lib,
    pkgs,
    ...
  }: let
    templates = "${pkgs.noctalia}/share/noctalia/assets/templates";
  in {
    # nix defaults beat ~/.config/mimeapps.list, which stays writable so programs can still register themselves.
    # each window manager links this as its <desktop>-mimeapps.list
    xdg.mimeApps.enable = true;
    xdg.configFile."mimeapps.list".enable = false;
    xdg.dataFile."applications/mimeapps.list".enable = false;
    gtk = {
      enable = true;
      colorScheme = "dark";
    };
    qt = {
      enable = true;
      style.name = lib.mkDefault "adwaita-dark";
    };
    programs.zathura.enable = true;
    user.theme.targets = {
      gtk3 = {
        template = "${templates}/gtk/gtk3.css";
        path = ".config/gtk-3.0/noctalia.css";
      };
      gtk4 = {
        template = "${templates}/gtk/gtk4.css";
        path = ".config/gtk-4.0/noctalia.css";
      };
      qt5ct = {
        template = "${templates}/qt/qtct.conf";
        path = ".config/qt5ct/colors/noctalia.conf";
      };
      qt6ct = {
        template = "${templates}/qt/qtct.conf";
        path = ".config/qt6ct/colors/noctalia.conf";
      };
    };
    home.pointerCursor = {
      enable = true;
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-dark";
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };
    home.packages = with pkgs; [
      brightnessctl
      thunderbird
      mpv
    ];
    services.playerctld.enable = true;
    imports = [
      ../home-manager/kitty.nix
      ../home-manager/dunst.nix
      ../home-manager/xcompose
      ../home-manager/imv.nix
    ];
  };
  imports = [
    ./sound.nix
  ];
}
