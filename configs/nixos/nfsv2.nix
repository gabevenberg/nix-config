{
  config,
  pkgs,
  lib,
  ...
}: {
  # will force you to compile kernel locally.
  services.nfs = {
    settings = {
      nfsd.vers2 = true;
    };
    server.enable = true;
  };
  boot.kernelPatches = [
    {
      name = "nfsv2";
      patch = null;
      extraStructuredConfig = {
        NFSD_V2 = lib.kernel.yes;
      };
    }
  ];
}
