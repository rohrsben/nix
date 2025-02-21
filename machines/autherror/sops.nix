{ inputs, config, lib, conf, ... }:

lib.optionalAttrs(conf.platform == "x86_64-linux") {
    imports = [
        inputs.sops-nix.nixosModules.sops
    ];
} // lib.optionalAttrs(conf.platform == "aarch64-darwin") {
    imports = [
        inputs.sops-nix.darwinModules.sops
    ];
} // {
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
}
