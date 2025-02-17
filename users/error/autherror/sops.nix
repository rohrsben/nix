{ inputs, ... }:

{
    imports = [
        inputs.sops-nix.homeManagerModules.sops
    ];

    sops = {
        age.keyFile = "/home/error/.config/sops/age/keys.txt";

        defaultSopsFile = ./../../../secrets/secrets.yaml;
        validateSopsFiles = false;

        secrets = {
            "gh-rohrsben" = {
                path = "/home/error/.ssh/gh-rohrsben";
            };

            "gh-rohrsben-pub" = {
                path = "/home/error/.ssh/gh-rohrsben.pub";
            };

            "umb-cs" = {
                path = "/home/error/.ssh/umb-cs";
            };

            "umb-cs-pub" = {
                path = "/home/error/.ssh/umb-cs.pub";
            };
        };
    };
}
