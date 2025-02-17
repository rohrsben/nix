{ inputs, ... }:

{
    # this enables a command-not-found database
    imports = [
        inputs.nix-index-database.hmModules.nix-index
    ];

    programs.nix-index-database.comma.enable = true;
}
