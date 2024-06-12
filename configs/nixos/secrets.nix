{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  secretsDirectory = builtins.toString (inputs.nix-secrets or "");
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  config = lib.mkIf (inputs ? nix-secrets) {
    sops = {
      defaultSopsFile = "${secretsDirectory}/common.yaml";
      validateSopsFiles = false;
      age = {
        sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true;
      };
    };
  };
}
