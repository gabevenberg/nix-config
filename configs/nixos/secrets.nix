{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  secretsDirectory = builtins.toString inputs.nix-secrets;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  sops = {
    defaultSopsFile = "${secretsDirectory}/common.yaml";
    validateSopsFiles = false;
  };
}
