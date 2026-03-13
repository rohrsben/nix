{ pkgs, ... }:

{
    home.packages = [
        pkgs.delta
    ];

    programs.git = {
        enable = true;

        settings = {
            user = {
                name = "rohrsben";
                email = "rohrsben@gmail.com";
            };
            init = {
                defaultBranch = "main";
            };
            core = {
                pager = "delta";
            };
            push = {
                autoSetupRemote = "true";
            };
            merge = {
                conflictStyle = "zdiff3";
            };
            interactive = {
                diffFilter = "delta --color-only";
            };
            delta = {
                navigate = "true";
                dark = "true";
                side-by-side = "true";
            };
            help = {
                autocorrect = "prompt";
            };
            diff = {
                algorithm = "histogram";
            };
            url = {
                "git@github.com:" = {
                    insteadOf = [ "gh:" "https://github.com/" ];
                };
            };
        };
    };
}
