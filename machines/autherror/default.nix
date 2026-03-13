{ conf, config, inputs, pkgs, ... }:

{
    imports = [
        inputs.sops-nix.nixosModules.sops
        ./disko.nix
        ../../users/error/autherror
    ];

    boot = {
        kernelModules = [ "kvm-intel" ];
        initrd = {
            availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
        };
        loader = {
            # see link below
            efi.canTouchEfiVariables = true;
            grub = {
                enable = true;
                efiSupport = true;
                enableCryptodisk = true;
                theme = "${pkgs.minimal-grub-theme}";
                # this is needed for efi, see https://discourse.nixos.org/t/question-about-grub-and-nodev/37867/6
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
        };
    };

    # TODO temp fix for okular see https://discourse.nixos.org/t/virtualbox-under-gnome/74450
    environment = {
        extraInit = ''
            export XDG_DATA_DIRS="$XDG_DATA_DIRS:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
        '';
    };

    fonts = {
        fontconfig.defaultFonts.emoji = [ "OpenMoji Color" ];
        packages = [
            pkgs.openmoji-color
            pkgs.dejavu_fonts
            pkgs.freefont_ttf
            pkgs.gyre-fonts
            pkgs.liberation_ttf
            pkgs.unifont
            pkgs.fira-code
            pkgs.nerd-fonts.symbols-only
            pkgs.nerd-fonts.jetbrains-mono
        ];
    };

    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
            inherit inputs conf;
        };
    };

    i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
            LC_ADDRESS = "en_US.UTF-8";
            LC_IDENTIFICATION = "en_US.UTF-8";
            LC_MEASUREMENT = "en_US.UTF-8";
            LC_MONETARY = "en_US.UTF-8";
            LC_NAME = "en_US.UTF-8";
            LC_NUMERIC = "en_US.UTF-8";
            LC_PAPER = "en_US.UTF-8";
            LC_TELEPHONE = "en_US.UTF-8";
            LC_TIME = "en_US.UTF-8";
        };
    };

    networking = {
        hostName = "autherror";
        networkmanager = {
            enable = true;
            wifi.macAddress = "random";
            settings.connection."autoconnect-retries" = 0;
        };
    };

    nix = {
        package = pkgs.lixPackageSets.stable.lix;
        settings.experimental-features = [ "nix-command" "flakes" ];
        gc = {
            automatic = true;
            options = "--delete-older-than 14d";
        };
        optimise.automatic = true;
    };

    nixpkgs = {
        config.allowUnfree = true;
        hostPlatform = "x86_64-linux";
        overlays = [
            (final: prev: {
                inherit (prev.lixPackageSets.stable)
                    nixpkgs-review
                    nix-eval-jobs
                    nix-fast-build
                    colmena;
            })
        ];
    };

    programs = {
        ssh.startAgent = true;
        fish.enable = true;
        localsend.enable = true;
        hyprland = {
            enable = true;
            xwayland.enable = true;
        };
    };

    hardware = {
        enableRedistributableFirmware = true;
        cpu.intel.updateMicrocode = true;
        bluetooth = {
            enable = true;
            settings = {
                General = {
                    DiscoverableTimeout = 30;
                    FastConnectable = true;
                };
            };
        };
        graphics.enable = true;
        nvidia = {
            modesetting.enable = true; # recommended for wayland
            open = true;
            package = config.boot.kernelPackages.nvidiaPackages.beta;
        };
    };

    services = {
        chrony = {
            enable = true;
            enableNTS = true;
            servers = [
                "time.google.com"
                "time.cloudflare.com"
                "ohio.time.system76.com"
                "oregon.time.system76.com"
                "virginia.time.system76.com"
            ];
            extraConfig = ''
                makestep 1 -1
            '';
        };
        fwupd.enable = true;
        xserver.videoDrivers = [ "nvidia" ];
        pipewire = {
            enable = true;
            pulse.enable = true;
            alsa.enable = true;
        };
        gvfs.enable = true; # used in calibre to mount kindle
        tailscale = {
            enable = true;
            extraSetFlags = [ "--ssh" ];
        };
        udisks2 = {
            enable = true;
            mountOnMedia = true;
        };
        greetd = {
            enable = true;
            settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'start-hyprland'";
        };
        udev.extraRules = ''
            SUBSYSTEM=="usb" ATTRS{idVendor}=="0483", ATTRS{idProduct}=="d11d", MODE="0660", TAG+="uaccess", TAG+="udev-acl", TAG+="DuckyPad Pro"
            SUBSYSTEM=="usb" ATTRS{idVendor}=="0483", ATTRS{idProduct}=="d11c", MODE="0660", TAG+="uaccess", TAG+="udev-acl", TAG+="DuckyPad"
            KERNEL=="hidraw*", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="d11d", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", TAG+="DuckyPad Pro"
            KERNEL=="hidraw*", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="d11c", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", TAG+="DuckyPad"
        '';
    };

    security = {
        # useful for pipewire, see https://wiki.nixos.org/wiki/PipeWire
        rtkit.enable = true;
    };

    sops = {
        defaultSopsFile = ../../secrets/secrets.yaml;
        validateSopsFiles = false;
        age = {
            # automatically import host SSH keys as age keys
            sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
            # this will use an age key that is expected to already be in the filesystem
            keyFile = "/var/lib/sops-nix/key.txt";
            # generate a new key if the key specified above does not exist
            generateKey = true;
        };
    };

    system.stateVersion = "24.11";

    systemd = {
        timers = {
            homeBackup = {
                description = "Backup for /home";
                wantedBy = [ "timers.target" ];
                timerConfig = {
                    Unit = "homeBackup.service";
                    OnCalendar = "daily";
                };
            };
            mouseBat = {
                description = "mouseBat Timer";
                wantedBy = [ "timers.target" ];
                timerConfig = {
                    Unit = "mouseBat.service";
                    OnBootSec = "10min";
                    OnUnitActiveSec = "2h";
                };
            };
        };

        services = {
            homeBackup = {
                path = [ pkgs.coreutils pkgs.ripgrep pkgs.btrfs-progs ];
                script = ''
                    set -eu

                    backupsDir="/mnt/lts/backups/home"

                    mkdir -p /tmp/homeBackup
                    cd /tmp/homeBackup

                    name="daily-$(date +"%y.%m.%d")"

                    btrfs subvolume snapshot -r /home "$name"
                    btrfs send "$name" | btrfs receive "$backupsDir"
                    btrfs subvolume delete "$name"

                    cd "$backupsDir"

                    while [ "$(ls | rg -c daily)" -gt 3 ]; do
                        current="$(ls | rg daily | sort | head -n 1)"
                        asWeekly="weekly-''${current: 6:6}$(( ((10#''${current: -2} - 1) / 7) + 1 ))"
                        if test -d "$asWeekly"; then
                            btrfs subvolume delete "$current"
                        else
                            mv "$current" "$asWeekly"
                        fi
                    done

                    while [ "$(ls | rg -c weekly)" -gt 3 ]; do
                        current="$(ls | rg weekly | sort | head -n 1)"
                        asMonthly="monthly-''${current: 7:5}"
                        if test -d "$asMonthly"; then
                            btrfs subvolume delete "$current"
                        else
                            mv "$current" "$asMonthly"
                        fi
                    done

                    while [ "$(ls | rg -c monthly)" -gt 3 ]; do
                        current="$(ls | rg monthly | sort | head -n 1)"
                        asYearly="yearly-''${current: 8:2}"
                        if test -d "$asYearly"; then
                            btrfs subvolume delete "$current"
                        else
                            mv "$current" "$asYearly"
                        fi
                    done
                '';

                serviceConfig = {
                    Type = "oneshot";
                    User = "root";
                };
            };
            mouseBat = {
                path = [ pkgs.coreutils pkgs.solaar pkgs.ripgrep ];
                script = ''
                    set -eu

                    outputs="/home/error/.scripts/outputs"

                    mkdir -p "$outputs"

                    output=$(solaar show G502 | rg --trim --max-count=1 Battery | cut -c 10-11)
                    if [ ! -z "$output" ]; then
                        echo "$output" > "$outputs/mouseBat"
                    fi
                '';
                serviceConfig = {
                    Type = "oneshot";
                    User = "root";
                };
            };
        };
    };

    time.timeZone = "America/New_York";

    users = {
        mutableUsers = false;
    };
}
