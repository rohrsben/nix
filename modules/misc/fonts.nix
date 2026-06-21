{
  den.aspects.fonts = {
    nixos = { pkgs, ... }: {
      fonts = {
        fontconfig.defaultFonts.emoji = [ "OpenMoji Color" ];
        packages = [
          pkgs.openmoji-color
          pkgs.dejavu_fonts
          pkgs.freefont_ttf
          pkgs.gyre-fonts
          pkgs.liberation_ttf
          pkgs.unifont
          pkgs.fira-code
          pkgs.nerd-fonts.symbols-only
          pkgs.nerd-fonts.jetbrains-mono
        ];
      };
    };
  };
}
