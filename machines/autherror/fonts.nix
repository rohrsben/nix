{ pkgs, ... }:

{
    fonts = {
        packages = with pkgs; [
            openmoji-color
            dejavu_fonts
            freefont_ttf
            gyre-fonts
            liberation_ttf
            unifont
            fira-code

            nerd-fonts.symbols-only
            nerd-fonts.jetbrains-mono
        ];
    };
}
