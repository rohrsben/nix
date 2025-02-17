{ pkgs, ... }:

let
    app = "discord-canary";
in {
    home.packages = [
        pkgs.${app}
    ];

    
}
