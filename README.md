Install process:

0. ssh-add the gh ssh key
  - TODO streamline this, can probably use https cloning and some extra commands in reinstall.sh
1. clone the repo (git clone git@github.com:rohrsben/nix), cd to `reinstall`
2. populate the necessary files in reinstall-files
3. run `./reinstall.sh <hostname>`
