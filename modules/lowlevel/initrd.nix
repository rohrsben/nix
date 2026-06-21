{
  den.aspects.initrd = {
    nixos = { pkgs, host, config, lib, ... }: {
      boot.kernelParams = [ "rd.systemd.debug_shell" ];
      boot.initrd = {
        availableKernelModules = [
          "ccm" "ctr" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"
          "iwlwifi" "e1000e" "iwlmvm" # wifi
          "tun" # tailscale
          "ext4" "jbd2" "mbcache" "crc16" # ext4
          "af_alg" "algif_hash" "algif_skcipher" "ecb" # iwd
          "md5" "cbc" "sha256" "cmac" "hmac" "sha1" "sha512" # iwd
          "des" "libdes" # des for iwd
        ];

        systemd = 
          let
            interface = "wlan0";
          in {
            users.root.shell = "/bin/systemd-tty-ask-password-agent";

            contents = {
              # insane
              "/etc/dbus-1".source = lib.mkForce ( pkgs.makeDBusConf.override {
                # taken wholesale from dbus.nix (see boot.initrd.systemd section), as of
                # nixpkgs#d2c949d725459d0dc2160f910b28cd2625c1d552

                # see also makeDBusConf/package.nix, hereafter mkDB

                # inherit (cfg) apparmor;
                  # in mkDB, this is "disabled" if left null.
                  # WARN for posterity in case I ever use apparmor, for now leaving null
                  # (to not deal with finding (cfg) access)

                dbus = pkgs.dbus; # hopefully this works

                suidHelper = "/bin/false"; # unchanged

                serviceDirectories = [
                  pkgs.dbus # translated from cfg.dbusPackage (hopefully)
                  config.boot.initrd.systemd.package # unchanged, should translate
                  pkgs.iwd
                ];


              } );

              "/etc/systemd/resolved.conf".text = lib.mkForce ''
                [Resolve]
                DNS=1.1.1.1
                FallbackDNS=8.8.8.8
              '';

              "/etc/pam.d/other".text = ''
                auth required pam_permit.so
                account required pam_permit.so
                password required pam_permit.so
                session required pam_permit.so
              '';
            };

            

            mounts = [{
              what = "/dev/disk/by-partlabel/disk-main-keys";
              where = "/keys";
              type = "ext4";
            }];

            targets = {
              initrd = {
                wants = [ "network.target" ];
              };
            };

            packages = [ pkgs.iwd ];
            initrdBin = [ pkgs.iwd pkgs.unixtools.ping pkgs.util-linux ];

            network = {
              enable = true;
              wait-online.anyInterface = true;
              networks = config.systemd.network.networks; # TODO this can be better encapsulated/
              # insulated (to allow more seamless den aspects). basically it currently expects aspects.networking
              # to exist and provide this info
            };

            storePaths = [
              "${pkgs.tailscale}/bin/tailscaled"
              "${pkgs.tailscale}/bin/tailscale"
              "${pkgs.iproute2}/bin/ip"
              "${pkgs.iwd}"
              "${pkgs.pam}/lib/security/pam_permit.so"
              "${pkgs.pam}/lib/libpam.so.0"
            ];

            services = {
              iwd-files = {
                requiredBy = [ "iwd.service" ];
                before = [ "iwd.service" ];
                after = [ "keys.mount" ];
                requires = [ "keys.mount" ];
                unitConfig.DefaultDependencies = false;
                script = ''
                  /bin/mkdir -p /var/lib/iwd

                  /bin/ln -sf -t /var/lib/iwd /keys/"$(cat /keys/wifi)"
                '';
              };

              # these are overrides to the provided iwd.service from pkgs.iwd
              iwd = {
                requiredBy = [ "network.target" ];
                unitConfig.DefaultDependencies = false;
              };

              tailscaled = {
                wantedBy = [ "initrd.target" ];
                path = [ pkgs.iproute2 ];
                after = [ "network.target" ];
                unitConfig.DefaultDependencies = false;
                before = [ "shutdown.target" ];
                conflicts = [ "shutdown.target" ];

                serviceConfig = {
                  Type = "notify";
                  RuntimeDirectory = "tailscale";
                  ExecStart = "${pkgs.tailscale}/bin/tailscaled --state=mem: --statedir=/run/tailscale --socket=/run/tailscale/tailscaled.sock --tun=userspace-networking";
                  Restart = "on-failure";
                };
              };

              tailscaled-autoconnect = {
                wantedBy = [ "initrd.target" ];
                after = [
                  "tailscaled.service"
                  "network-online.target"
                ];
                wants = [ "network-online.target" ];
                requires = [ "tailscaled.service" ];

                unitConfig.DefaultDependencies = false;
                before = [ "shutdown.target" ];
                conflicts = [ "shutdown.target" ];

                serviceConfig = {
                  Type = "oneshot";
                  RemainAfterExit = true;
                  Restart = "on-failure";
                  RestartSec = 5;
                };
                script = ''
                  ${pkgs.tailscale}/bin/tailscale --socket=/run/tailscale/tailscaled.sock up \
                  --hostname=${host.hostName}-initrd \
                  --auth-key=file:/keys/tailscale.key \
                  --netfilter-mode=off \
                  --ssh
                '';
              };
            };
          };
      };
    };
  };
}
