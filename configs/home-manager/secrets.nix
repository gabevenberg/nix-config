{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  secretsDirectory = builtins.toString inputs.nix-secrets;
in {
  sops = {
    defaultSopsFile = "${secretsDirectory}/common.yaml";
    validateSopsFiles = false;
    age = {
      sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
      keyFile = "${config.home.homeDirectory}/.config/sops-nix/key.txt";
      generateKey = true;
    };
  };
}
