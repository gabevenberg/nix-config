{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  port = "3923";
in {
  nixpkgs.overlays = [inputs.copyparty.overlays.default];
  environment.systemPackages = with pkgs; [copyparty];
  services.copyparty = {
    enable = true;
    # directly maps to values in the [global] section of the copyparty config.
    # see `copyparty --help` for available options
    settings = {
      i = "127.0.0.1";
      p = port;
      ed = true;
      e2dsa = true;
      # hist = "/storage/copyparty";
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
    };

    # create users
    accounts = {
      # gabe.passwordFile = "/run/keys/copyparty/k_password";
    };

    # create a volume
    volumes = {
      "/" = {
        path = "/storage/syncthing/";
        # see `copyparty --help-accounts` for available options
        access = {
          r = "*";
          A = "*";
          # rw = ["gabe" "erica"];
        };
        # see `copyparty --help-flags` for available options
        flags = {
          # "fk" enables filekeys (necessary for upget permission) (4 chars long)
          fk = 4;
          # scan for new files every 60sec
          scan = 600;
          # volflag "e2d" enables the uploads database
          e2d = true;
          # "d2t" disables multimedia parsers (in case the uploads are malicious)
          d2t = false;
        };
      };
    };
    # you may increase the open file limit for the process
    openFilesLimit = 8192;
  };
}
