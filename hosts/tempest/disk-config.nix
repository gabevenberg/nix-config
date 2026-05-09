{
  disko.devices = {
    disk = {
      ssd = {
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S6S1NJ0T811402B";
        type = "disk";
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
                mountOptions = ["umask=0077"];
              };
            };
            btrfs = {
              type = "btrfs";
              extraArgs = ["-L" "nixos" "-f"];
              subvolumes = {
                "ssdgames" = {
                  mountpoint = "/ssdgames";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "root" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
      hdd = {
        device = "/dev/disk/by-id/ata-WDC_WD120EDBZ-11B1HA0_5QJDE14B";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            btrfs = {
              type = "btrfs";
              extraArgs = ["-L" "home" "-f"];
              subvolumes = {
                "home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "swap" = {
                  mountpoint = "/.swapvol";
                  swap.swapfile.size = "32G";
                  swap.swapfile.priority = 0;
                };
              };
            };
          };
        };
      };
    };
  };
}
