{ inputs, pkgs, ... }:

{
    imports = [
        inputs.grub2-themes.nixosModules.default
    ];

    boot = {
        initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
        initrd.kernelModules = [ ];
        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];
        
        kernelPackages = pkgs.linuxPackages_zen;
        
        loader = {
            efi.canTouchEfiVariables = true;

            grub = {
                enable = true;

                efiSupport = true;
                enableCryptodisk = true;
                device = "nodev";

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

            grub2-theme = {
                enable = true;
                theme = "stylish";
                footer = true;
                customResolution = "2560x1440";
            };
        };
    };

    hardware = {
        enableRedistributableFirmware = true;
        cpu.intel.updateMicrocode = true;
    };
}
