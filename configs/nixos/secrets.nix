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
    validateSopsFiles = false;
    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };
}
