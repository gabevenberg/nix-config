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
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      bigclock = "en";
    };
  };
  services.accounts-daemon.enable = true;
  nixpkgs.config.zathura.useMupdf = true;
  programs.dconf.enable = true;
  home-manager.users.${config.host.details.user} = {...}: {
    gtk = {
      enable = true;
      colorScheme = "dark";
    };
    qt = {
      enable = true;
      style.name = "adwaita-dark";
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
      ../home-manager/rofi.nix
      ../home-manager/dunst.nix
      ../home-manager/xcompose
      ../home-manager/imv.nix
    ];
  };
  imports = [
    ./sound.nix
  ];
}
