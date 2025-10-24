{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  port = "3923";
  defaultvolflags = {
    scan = 60;
    grid = true;
    nsort = true;
    fk = 8;
  };
in {
  nixpkgs.overlays = [inputs.copyparty.overlays.default];
  environment.systemPackages = with pkgs; [copyparty];
  services.copyparty = {
    enable = true;
    user = config.host.details.user;
    group = "users";
    # directly maps to values in the [global] section of the copyparty config.
    # see `copyparty --help` for available options
    settings = {
      # i = "127.0.0.1";
      p = port;
      ed = true;
      e2dsa = true;
      forget-ip = 1440;
      e2ts = true;
      shr = "/share";
      shr-adm = "gabe";
      u2abort = 3;
      magic = true;
      df = 5;
      u2j = 16;
      ls = "**,*,ln,p,r";
      xvol = true;
      xdev = true;
      no-logues = true;
      no-robots = true;
      md-hist = "v";
      nsort = true;
      log-utc = true;
      ah-alg = "argon2";
      ah-salt = "ImSaltyAboutNonPersistentSalts";
      hist = "/var/lib/copyparty";
      xff-hdr = "X-Forwarded-For";
      rproxy = 1;
    };
    accounts = lib.mkIf (inputs ? nix-secrets) (
      builtins.mapAttrs (name: value: {passwordFile = "${inputs.nix-secrets}/copyparty/${name}";})
      (builtins.readDir "${inputs.nix-secrets}/copyparty")
    );
    volumes = {
      "/" = {
        path = "/storage/syncthing/family";
        access = {
          rwmd = ["gabe" "erica"];
          A = ["gabe"];
        };
        flags = defaultvolflags;
      };
      "/gabe" = {
        path = "/storage/syncthing/gabe";
        access = {
          rwmd = "gabe";
          A = ["gabe"];
        };
        flags = defaultvolflags;
      };
      "/erica" = {
        path = "/storage/syncthing/erica";
        access = {
          rwmd = "erica";
          A = ["erica"];
        };
        flags = defaultvolflags;
      };
    };
    # you may increase the open file limit for the process
    openFilesLimit = 8192;
  };

  services.nginx.virtualHosts."files.venberg.xyz" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${port}";
    };
  };
}
