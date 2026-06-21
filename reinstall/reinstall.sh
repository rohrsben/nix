#!/usr/bin/env bash

mkdir -p reinstall-files

if [[ -z $1 ]]; then
    echo "Flake output/hostname not set. Rerun like: ./reinstall.sh <hostname>"
    exit 1
fi

if [ ! -f "reinstall-files/wifi" ]; then
    echo "wifi missing from reinstall-files. Please add and re-run"
    exit 1
fi

necessary_files=("disko.key" "tailscale.key" "identity" "$(cat reinstall-files/wifi)")
for nf in "${necessary_files[@]}"; do
    if [ ! -f "reinstall-files/$nf" ]; then
        echo "$nf missing from reinstall-files. Please add and re-run."
	exit 1
    fi
done

necessary_commands=("sops" "ssh-to-age")
for nc in "${necessary_commands[@]}"; do
    if ! command -v "$nc" &> /dev/null; then
        echo "Missing some commands. Re-run after executing:"
	echo "nix shell --experimental-features \"nix-command flakes\" nixpkgs#sops github:mic92/ssh-to-age"
	exit 1
    fi
done

mkdir -p /tmp/reinstall
cp reinstall-files/disko.key /tmp/reinstall

# format the disk
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ../modules/disko/_$1.nix --yes-wipe-all-disks

# ensure files for initrd tailscale
mkdir keys-part
sudo mount /dev/disk/by-partlabel/disk-main-keys keys-part
sudo cp reinstall-files/{tailscale.key,wifi,"$(cat reinstall-files/wifi)"} keys-part
sudo umount keys-part

# handle host key creation/enrollment
mkdir host-ssh
if [ -f "reinstall-files/host" ]; then
    cp reinstall-files/host host-ssh/ssh_host_ed25519_key
    ssh-keygen -y -f host-ssh/ssh_host_ed25519_key > host-ssh/ssh_host_ed25519_key.pub
else
    # generate the new key
    ssh-keygen -q -N "" -t ed25519 -f host-ssh/ssh_host_ed25519_key

    # enroll into sops and rotate keys if a sops file exists for the host already
    if [ -f "../secrets/host_$1.yaml" ]; then
        mkdir age-keys
        ssh-to-age -i host-ssh/ssh_host_ed25519_key.pub -o age-keys/host_age.pub
        awk -i inplace -v HOSTNAME="$1" -v NEW_KEY="$(cat age-keys/host_age.pub)" '$0 ~ ("&host_" HOSTNAME) {sub(/[[:space:]]+[^[:space:]]+$/, (" " NEW_KEY))}1' ../secrets/.sops.yaml
        
	# reencrypt using the identity key
	ssh-to-age -private-key -i reinstall-files/identity -o age-keys/IDENTITY_PRIV
	SOPS_AGE_KEY_FILE=age-keys/IDENTITY_PRIV sops --config ../secrets/.sops.yaml updatekeys -y ../secrets/host_$1.yaml
    fi
fi

# copy in the host keys
sudo mkdir -p /mnt/etc/ssh
sudo cp host-ssh/* /mnt/etc/ssh

# install nixos
sudo nixos-install --no-root-password --flake ..#autherror

# copy the wifi config
sudo mkdir -p /mnt/var/lib/iwd
sudo cp reinstall-files/"$(cat reinstall-files/wifi)" /mnt/var/lib/iwd

# copy in the identity key
sudo mkdir /mnt/home/error/.ssh
sudo chown +1000 /mnt/home/error/.ssh
sudo cp reinstall-files/identity /mnt/home/error/.ssh
sudo chmod 600 /mnt/home/error/.ssh/identity
sudo chown +1000 /mnt/home/error/.ssh/identity

# clean up
rm -r age-keys
rm -r host-ssh
rm -r keys-part
rm -r reinstall-files

# TODO git commit to update remote secrets
