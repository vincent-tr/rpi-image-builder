#!/bin/sh

# packages
apk add --no-cache sudo sshfs git

# create user
adduser -D builder
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

home=/home/builder
rmount_build=$home/alpine-build-home-resources
rmount_packages=$home/alpine-packages-home-resources

# add ssh key for alpine-build@home-resources
sudo -i -u builder /bin/sh - << eof

mkdir -p $home/.ssh
ssh-keyscan home-resources > $home/.ssh/known_hosts
scp -r root@home-resources:/home/alpine-build/ssh-keys/* $home/.ssh/
chmod 700 $home/.ssh

eof

# add ssh mount
sudo -i -u builder /bin/sh - << eof

sudo modprobe fuse
ruid=\$(ssh alpine-build@home-resources id -u)
rgid=\$(ssh alpine-build@home-resources id -g)
mkdir -p $rmount_build
sshfs -o uid=\$ruid,gid=\$rgid alpine-build@home-resources:/home/alpine-build $rmount_build
# umount : fusermount -u $rmount_build
mkdir -p $rmount_packages
sshfs -o uid=\$ruid,gid=\$rgid alpine-build@home-resources:/var/www/alpine-packages $rmount_packages
# umount : fusermount -u $rmount_packages

eof

# prepare git repo
sudo -i -u builder /bin/sh - << eof

cd ~
git clone https://github.com/vincent-tr/rpi-image-builder

eof
