{
  den.aspects.scripts = {
    homeManager = {
      home.file.".scripts/powermenu.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env fish

          set options "Restart
          Power off"

          set result (echo $options | fuzzel -d --width=10 --lines=2 --hide-prompt )

          if test -n "$result"
              if test "$result" = "Restart"
                  systemctl reboot
              else if test "$result" = "Power off"
                  systemctl poweroff
              end
          end
        '';
      };
    };
  };
}
