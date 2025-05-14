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
  betapackage = let
    pyEnv = pkgs.python3.withPackages (
      python-pkgs:
        with python-pkgs; [
          jinja2
          pillow
          pkgs.ffmpeg
          mutagen
          argon2-cffi
        ]
    );
  in
    pkgs.stdenv.mkDerivation {
      pname = "copyparty";
      version = "1.17.0";
      src = pkgs.fetchurl {
        url = "https://ocv.me/copyparty/beta/copyparty-sfx.py";
        hash = "sha256-vXx+4Stax/HH+eIc1ktYM+zuoRxEB2mxfoY7haPAID4=";
      };
      buildInputs = [pkgs.makeWrapper];
      dontUnpack = true;
      dontBuild = true;
      installPhase = ''
        install -Dm755 $src $out/share/copyparty-sfx.py
        makeWrapper ${pyEnv.interpreter} $out/bin/copyparty \
          --set PATH '${lib.makeBinPath [pkgs.util-linux pkgs.ffmpeg]}:$PATH' \
          --add-flags "$out/share/copyparty-sfx.py"
      '';
      meta.mainProgram = "copyparty";
    };
in {
  nixpkgs.overlays = [inputs.copyparty.overlays.default];
  environment.systemPackages = with pkgs; [copyparty];
  services.copyparty = {
    enable = true;
    package = betapackage;
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
