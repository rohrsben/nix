{
  den.aspects.grub = {
    nixos = { pkgs, ... }: {
      boot.loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          enable = true;
          efiSupport = true;
          enableCryptodisk = true;
          theme = "${pkgs.minimal-grub-theme}";
          device = "nodev"; # see https://discourse.nixos.org/t/question-about-grub-and-nodev/37867/6
          extraEntries = ''
            menuentry "Windows" --class windows {
                insmod part_gpt
                insmod fat
                insmod chain
                set root='(hd2,gpt1)'
                search --no-floppy --fs-uuid --set=root 0A13-1C9C
                chainloader /EFI/Microsoft/Boot/bootmgfw.efi
            }
          '';
        };
      };
    };
  };
}
