{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_2TB_S59CNJ0N400844P_1";
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
            mountOptions = [
              "umask=0077"
            ];
          };
        };
        keys = {
          size = "100M";
          content = {
            type = "filesystem";
            format = "ext4";
          };
        };
        swap = {
          size = "4G";
          content = {
            type = "swap";
            randomEncryption = true;
          };
        };
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "cryptroot";
            passwordFile = "/tmp/reinstall/disko.key";
            extraOpenArgs = [
              "--allow-discards"
              "--perf-no_read_workqueue"
              "--perf-no_write_workqueue"
            ];
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "@" = {
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
