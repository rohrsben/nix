{ inputs, pkgs, ... }:

{
    home.sessionVariables = {
        hydro_color_pwd = "brblack";
        hydro_color_prompt = "green";
        school = "/mnt/lts/school/25-spring";
        media = "/mnt/lts/media";
    };

    programs.fish = {
        enable = true;

        shellAliases = {
            cat = "bat";
            cls = "clear; ls";
            t = "eza -T";
            ls = "eza";
            lr = "eza -R --absolute | rg";
            lsa = "eza -a";
            lsl = "eza -l";
            lg = "lazygit";
            rebuild = "nh os switch /home/error/nix --hostname autherror";
            rebuild-boot = "nh os boot /home/error/nix --hostname autherror";
            icat = "kitten icat";
            cd = "z";
            restart = "systemctl stop tailscaled.service && systemctl reboot";
        };

        functions = {
            autols = {
                onVariable = "PWD";
                body = ''
                    eza;
                '';
            };

            fish_greeting = {
                body = ''
                    autols
                '';
            };

            a = {
                body = ''
                    set -U a (pwd)
                    echo "anchored $a"
                '';
            };

            ua = {
                body = ''
                    set -U a
                    echo "set sail"
                '';
            };

            add-idents = {
                body = ''
                    set idents /home/error/.ssh/gh-rohrsben /home/error/.ssh/umb-cs
                    for ident in $idents
                        ssh-add $ident
                    end
                '';
            };

            unnix = {
                body = ''
                    for file in $argv
                        set newname $file-unnix
                        mv $file $newname
                        cat $newname > $file
                    end
                '';
            };

            renix = {
                body = ''
                    if test -z $argv
                        set files (command ls)
                        for file in $files
                            if test (string sub --start -5 $file) = unnix
                                set oldname (string sub --end=-6 $file)
                                if test -e $oldname
                                    mv $oldname $oldname-edited
                                end
                                mv $file $oldname
                            end
                        end
                    else
                        for file in $argv
                            mv $file $file-edited
                            mv $file-unnix $file
                        end
                    end
                '';
            };

            mv-edited = {
                body = ''
                    set files (ls $argv[1] | rg edited)
                    for file in $files;
                        set name (string sub -e -7 $file)
                        rm $argv[2]/$name
                        mv $argv[1]/$file $argv[2]/$name
                        echo "switched $name"
                    end
                '';
            };
        };

        plugins = [
            {
                name = "hydro";
                src = pkgs.fetchFromGitHub {
                    owner = "jorgebucaran";
                    repo = "hydro";
                    rev = "62e4d2cc6e284de830dbb88df8f03d7b1bb68eb8";
                    sha256 = "sha256-fmvG6xsfcfsgjjU10FyhKbxmsrIOCu+0B5hwynFMpsY=";
                };
            }
        ];
    };
}
