{
  den.aspects.scripts = {
    homeManager = {
      home.file.".scripts/powermenu.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env fish

          set options "Restart
          Power off"

          set result (echo $options | tofi --prompt-text="" --width=290 --height=180 --padding-top=0 --padding-bottom=0 --padding-left=50 --padding-right=0)

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
