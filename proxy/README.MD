# How To Install

attach nixos minimal ISO

just sudo yourself so you don't have to type it
* `sudo -i`

find disk
* `lsblk`

wipe all tables on disk
* `wipefs -a /dev/vda`

make new table (gpt)
* `parted /dev/vda -- mklabel msdos`

make main ext4
* `parted /dev/vda -- mkpart primary 1MB -8GB`

set boot flag
* `parted /dev/vda -- set 1 boot on`

make swap
* `parted /dev/vda -- mkpart primary linux-swap -8GB 100%`

formating
* `mkfs.ext4 -L nixos /dev/vda1`
* `mkswap -L swap /dev/vda2`

mount root
* `mount /dev/disk/by-label/nixos /mnt`

swap
* `swapon /dev/vda2`

make config
* `nixos-generate-config --root /mnt`

get config from github
* `nix-shell -p git`
* `mkdir /tmp/tmp-git-repo`
* `cd /tmp/tmp-git-repo`
* `git clone https://github.com/Evolved-Cow-Man/personal-nix-configuration.git`
* `mv /tmp/tmp-git-repo/personal-nix-configuration/proxy/configuration.nix /mnt/etc/nixos/configuration.nix`
* `exit`
* `rm -rf /tmp/tmp-git-repo`
* `cd /`

make sure it looks right
* `nano /mnt/etc/nixos/configuration.nix`

hope, lol - and set root password
* `nixos-install`

shutdown then remove install iso in dashboard
* `sudo shutdown now`

get the tty from the dashboard to set the user password too
