{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  secretsPath = builtins.toString inputs.nix-secrets;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops={
    defaultSopsFile="${secretsPath}/secrets.yaml";
    age={
      sshKeyPaths=["${config.home.homeDirectory}/keys/age/master.txt"];
      keyFile="/var/lib/sops-nix/key.txt";
      generateKey=true;
    };
  };
}
