{ pkgs, ... }:

pkgs.stdenvNoCC.mkDerivation {
    name = "colloid-gtk-personal";

    src = pkgs.fetchFromGitHub {
        owner = "vinceliuice";
        repo = "colloid-gtk-theme";
        rev = "15f9b99ef447b183b7f27364897edc8834462d41";
        hash = "sha256-UgRQfv13xmtyZI72fuq3/ytyZGSIuZ481RawEe5Wzio=";
    };

    nativeBuildInputs = [
        pkgs.jdupes
        pkgs.sassc
    ];

    buildInputs = [
        pkgs.gnome-themes-extra
    ];

    propagatedUserEnvPkgs = [
        pkgs.gtk-engine-murrine
    ];

    postPatch = ''
        patchShebangs install.sh
    '';

    installPhase = ''
        runHook preInstall

        name= HOME="$TMPDIR" ./install.sh --size standard --theme red --color dark --tweaks everforest rimless normal --dest "$out/share/themes"

        jdupes --quiet --link-soft --recurse "$out/share"

        runHook postInstall
    '';
}
