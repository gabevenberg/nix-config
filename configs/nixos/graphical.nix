{
  config,
  pkgs,
  ...
}: {
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
  home-manager.users.${config.host.details.user} = {...}: {
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
      style.name = "adwaita-dark";
    };
    home.pointerCursor = {
      enable=true;
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-dark";
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };
    home.packages = with pkgs; [
      brightnessctl
      firefox
      thunderbird
      mpv
      zathura
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
    ./greetd/tuigreet.nix
  ];
}
