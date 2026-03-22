{
  disko.devices = {
    disk = {
      ssd = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-PC711_NVMe_SK_hynix_256GB____FNAAN64121210AP27";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
      zfsa = {
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x5000cca27ed9174d";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "storage";
              };
            };
          };
        };
      };
      zfsb = {
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x5000cca27ed8106c";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "storage";
              };
            };
          };
        };
      };
    };
    zpool = {
      storage = {
        type = "zpool";
        mode = "mirror";
        rootFsOptions = {
          compression = "zstd";
          mountpoint = "/storage";
        };
        datasets = {
          # This does not reflect reality,
          # I was stupid and didnt put /var/lib on zfs,
          # so now I just have datasets for a few folders in it.
          lib = {
            type = "zfs_fs";
            options = {
              compression = "zstd";
              mountpoint = "/var/lib";
            };
          };
          postgres = {
            type = "zfs_fs";
            options = {
              mountpoint = "/var/lib/postgresql";
              recordsize = "8K";
              primarycache = "metadata";
            };
          };
          backup = {
            type = "zfs_fs";
            options = {
              mountpoint = "/backup";
              quota = "6T";
            };
          };
        };
      };
    };
  };
}
