{
  disko.devices = {
    disk = {
      ssd = {
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x500a0751e138c24b";
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
        options.mountpoint = "/storage";
        rootFsOptions = {
          compression = "zstd";
        };

        datasets = {
          dataset = {
            type = "zfs_fs";
            options.mountpoint = "/storage/dataset";
          };
        };
      };
    };
  };
}
