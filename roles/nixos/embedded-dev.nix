{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../configs/nixos/distrobox.nix
  ];
  home-manager.users.${config.host.details.user} = {config, ...}: {
    home.packages = with pkgs; [
      tio
    ];
  };
}
