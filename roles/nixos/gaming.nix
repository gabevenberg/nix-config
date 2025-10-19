{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  hardware.steam-hardware.enable = true;
  home-manager.users.${config.host.details.user} = {config, ...}: {
    home.packages = with pkgs; [
      discord
    ];
  };
}
