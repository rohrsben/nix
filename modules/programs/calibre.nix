{
  # TODO ambiguate the location of the calibre library, so multi-user is better/easier
  den.aspects.calibre = {
    nixos = { pkgs, ...}: {
      services.gvfs.enable = true;
    };

    homeManager = { pkgs, lib, ... }:
      let
        cal-kfx = pkgs.dockerTools.pullImage {
          imageName = "yshalsager/calibre-with-kfx";
          imageDigest = "sha256:2935bde14178fccd089680803ab7c98fe5de5b012d7a5420a25213cdcddb8dfe";
          sha256 = "sha256-J575d2WowkZk4omv4z8e5aYKGIrgF/bZa9Pn9NEQ4gU=";
          finalImageName = "ebook-converter";
          finalImageTag = "latest";
        };
        inputs = [ pkgs.podman pkgs.libnotify pkgs.calibre pkgs.busybox ];
        base = pkgs.writers.writePython3Bin "converter" { doCheck = false; }
          ''
            import subprocess
            from pathlib import Path

            dls = Path("/home/error/downloads")

            def notify(msg):
                subprocess.run(["notify-send", msg])

            target = list(dls.glob('*.epub'))[0]
            print(f"Processing: {target}")
            notify(f'Converting: {target.stem}')

            workdir = dls / "workspace"
            workdir.mkdir()

            epub = workdir / "source.epub"
            kfx = workdir / "output.kfx"

            try:
                target.replace(epub)

                subprocess.run(['podman', 'load', '-q', '-i', '${cal-kfx}'])

                cmd = [
                    'podman', 'run',
                    '--userns=keep-id',
                    '--user', '1000:1000',
                    '--rm',
                    '-v', f'{workdir}:/app:rw',
                    'ebook-converter:latest', 'source.epub', 'output.kfx'
                ]
                subprocess.run(cmd, check=True)

                if not kfx.is_file():
                    raise FileNotFoundError("Problem with the conversion")


                calibre_running = subprocess.run(['pgrep', '-f', 'calibre'])
                if calibre_running.returncode == 0:
                    print('Calibre is running.')
                    cmd = [
                        'calibredb', '--with-library', 'http://localhost:8080/#calibre',
                        'add', '--automerge', 'overwrite', f'{kfx}'
                    ]
                    subprocess.run(cmd, check=True)
                else:
                    print('Calibre is closed')
                    cmd = [
                        'calibredb', '--with-library', '/home/error/xdg/documents/calibre',
                        'add', '--automerge', 'overwrite', f'{kfx}'
                    ]
                    subprocess.run(cmd, check=True)

                notify('Added book to Calibre')
                epub.unlink()

            except Exception as e:
                print(f'Error: {e}')
                notify('Fuck')

                new_name = epub.parent.parent / f"{target}-failed"
                epub.rename(new_name)

            finally:
                kfx.unlink(missing_ok=True)
                workdir.rmdir()
          '';
        script = pkgs.symlinkJoin {
          name = "converter";
          paths = [ base ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/converter --prefix PATH : ${pkgs.lib.makeBinPath inputs}
          '';
        };
      in {
        home.packages = [ pkgs.calibre ];

        systemd.user = {
          paths.ebookConverter = {
            Path = {
              PathExistsGlob = "/home/error/downloads/*.epub";
            };
            Install.WantedBy = [ "graphical-session.target" ];
          };

          services.ebookConverter = {
            Service = {
              Type = "oneshot";
              ExecStart = "${script}/bin/converter";
            };
          };
        };
      };
  };
}
