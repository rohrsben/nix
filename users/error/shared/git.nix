{ pkgs, ... }:

{
    programs.git = {
        enable = true;

        userName = "rohrsben";
        userEmail = "rohrsben@gmail.com";

        extraConfig = {
            init = {
                defaultBranch = "main";
            };
            push = {
                autosetupremote = "true";
            };
            merge = {
                conflictstyle = "zdiff3";
            };
            help = {
                autocorrect = "prompt";
            };
            diff = {
                algorithm = "histogram";
            };
        };
    };
}
