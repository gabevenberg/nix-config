{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.curl];
  sops = lib.mkIf (inputs ? nix-secrets) {
    secrets.ntfy-url.sopsFile = "${inputs.nix-secrets}/ntfy.yaml";
  };
}
