{ ... }:

{
    services.udev = {
        extraRules = ''
            SUBSYSTEM=="usb" ATTRS{idVendor}=="0483", ATTRS{idProduct}=="d11d", MODE="0660", TAG+="uaccess", TAG+="udev-acl", TAG+="DuckyPad Pro"
            SUBSYSTEM=="usb" ATTRS{idVendor}=="0483", ATTRS{idProduct}=="d11c", MODE="0660", TAG+="uaccess", TAG+="udev-acl", TAG+="DuckyPad"
            KERNEL=="hidraw*", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="d11d", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", TAG+="DuckyPad Pro"
            KERNEL=="hidraw*", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="d11c", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", TAG+="DuckyPad"
        '';
    };
}
