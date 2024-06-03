{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports=[
  ../../configs/nixos/secrets.nix
  ];
  sops.secrets.gv-password = {
    neededForUsers = true;
  };
}
