{ pkgs, ... }:

pkgs.stdenvNoCC.mkDerivation {
    name = "colloid-icon-personal";

    src = pkgs.fetchFromGitHub {
        owner = "vinceliuice";
        repo = "colloid-icon-theme";
        rev = "da7e0edede97d7e95f3c235d13f177c5189ef23d";
        hash = "sha256-g1ICV3Ccn4wo/mq7wT7jyuggh2JA+fGTa7/wtL74vbs=";
    };

    nativeBuildInputs = [ pkgs.gtk3 pkgs.jdupes ];
    propagatedBuildInputs = [ pkgs.hicolor-icon-theme ];

    dontDropIconThemeCache = true;

    dontPatchELF = true;
    dontRewriteSymlinks = true;

    postPatch = ''
        patchShebangs install.sh
    '';

    configurePhase = ''
        rm links/apps/scalable/io.github.vinegarhq.Vinegar.studio.svg
    '';

    installPhase = ''
        runHook preInstall

        name= ./install.sh --scheme everforest --theme grey --dest $out/share/icons
        jdupes --quiet --link-soft --recurse $out/share

        runHook postInstall
    '';

    passthru.updateScript = pkgs.gitUpdater { };
}
