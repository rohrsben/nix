{ den, ... }: {
  den.aspects.autherror = {
    includes = with den.aspects; [
      # lowlevel
      bluetooth
      cpu
      disko
      grub
      initrd
      nvidia
      zswap

      # os
      chrony
      fwupd
      locale
      networking
      pipewire
      udisks2
      podman

      # misc
      fonts
      nix-config
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
