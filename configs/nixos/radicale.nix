{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  services.radicale={
    enable=true;
    settings={
      server={
        hosts=[ "0.0.0.0:5232" "[::]:5232" ];
      };
      auth={
        type="htpasswd";
        htpasswd_encryption="md5";
        htpasswd_filename="${inputs.nix-secrets}/radicale-users";
      };
    };
  };
  networking.firewall.allowedTCPPorts = [5232];
}
