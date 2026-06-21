{ den, ... }: {
  den.aspects.autherror = {
    includes = [
      # lowlevel
      den.aspects.bluetooth
      den.aspects.cpu
      den.aspects.disko
      den.aspects.grub
      den.aspects.initrd
      den.aspects.nvidia
      den.aspects.zswap

      # os
      den.aspects.chrony
      den.aspects.fwupd
      den.aspects.locale
      den.aspects.networking
      den.aspects.pipewire
      den.aspects.udisks2

      # misc
      den.aspects.fonts
      den.aspects.nix-config
    ];

    nixos = {
      imports = [ ../modules/disko/_autherror.nix ];

      programs.ssh.knownHosts = {
        "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };

      users = {
        # TODO look into userborn / sysusers
        mutableUsers = false;
      };
    };
  };
}
