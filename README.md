# Personal Nix Configuration
Repository for my personal NixOS configuration files.

# How To Maintain
edit and update
* `sudo nano /etc/nixos/configuration.nix`
* `sudo nix-channel --update`
* `sudo nixos-rebuild switch`
* `sudo reboot now`

clean up (if i feel the system is stable)
* `sudo nix-collect-garbage`
* `sudo nix-collect-garbage -d`
* `sudo nix-env --delete-generations +3`
* `sudo nix-store --optimize`
* `sudo reboot now`

# How To Install
get network

just sudo yourself so you don't have to type it
* `sudo -i`

find disk
* `ls /dev/sd*`

wipe all tables on disk
* `wipefs -a /dev/sdx`

make new table (gpt)
* `parted /dev/sdx -- mklabel gpt`

make main btrfs
* `parted /dev/sdx -- mkpart root btrfs 512MB -8GB`

make swap
* `parted /dev/sdx -- mkpart swap linux-swap -8GB 100%`

make boot
* `parted /dev/sdx -- mkpart ESP fat32 1MB 512MB`
* `parted /dev/sdx -- set 3 esp on`

formating
* `mkfs.btrfs -L nixos /dev/sdx1`
* `mkswap -L swap /dev/sdx2`
* `mkfs.fat -F 32 -n boot /dev/sdx3`

mount this thing
* `mount /dev/disk/by-label/nixos /mnt`

uefi things
* `mkdir -p /mnt/boot`
* `mount -o umask=077 /dev/disk/by-label/boot /mnt/boot`

swap
* `swapon /dev/sda2`

make config
* `nixos-generate-config --root /mnt`

get config from github
* `nix-shell -p git`
* `mkdir /tmp/tmp-git-repo`
* `cd /tmp/tmp-git-repo`
* `git clone https://github.com/Evolved-Cow-Man/personal-nix-configuration.git`
* `mv /tmp/tmp-git-repo/personal-nix-configuration/personal/configuration.nix /mnt/etc/nixos/configuration.nix`
* `exit`
* `rm -rf /tmp/tmp-git-repo`
* `cd /`

make sure it looks right
* `nano /mnt/etc/nixos/configuration.nix`

hope, lol - and set root password
* `nixos-install`

if it all worked and boot order is right / USB is out.
* `reboot now`

I don't use encryption on my main disk as it does not use tpm like windows, 
seems like a pain to get it to work. The file system being immutable apart from 
my home folder should mean that I can be more careful and just keep anyhting 
the feds want on another drive. If I care more about it later this is something 
to look into: https://nixos.wiki/wiki/ECryptfs. You'll also need to setup your 
password before using sddm due to it not liking passwordless login (get into a 
TTY).
* `passwd`
