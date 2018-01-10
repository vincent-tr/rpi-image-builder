#!/bin/sh

# packages
apk add --no-cache --virtual .build-utils sudo sshfs git alpine-sdk

# create user
adduser -D builder
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

home=/home/builder
rmount_build=$home/alpine-build-home-resources
rmount_packages=$home/alpine-packages-home-resources

sudo -i -u builder /bin/sh - << eof

# add ssh key for alpine-build@home-resources
mkdir -p $home/.ssh
ssh-keyscan home-resources > $home/.ssh/known_hosts
scp -r root@home-resources:/home/alpine-build/ssh-keys/* $home/.ssh/
chmod 700 $home/.ssh

# add ssh mount
sudo modprobe fuse
ruid=\$(ssh alpine-build@home-resources id -u)
rgid=\$(ssh alpine-build@home-resources id -g)
mkdir -p $rmount_build
sshfs -o uid=\$ruid,gid=\$rgid alpine-build@home-resources:/home/alpine-build $rmount_build
# umount : fusermount -u $rmount_build
mkdir -p $rmount_packages
sshfs -o uid=\$ruid,gid=\$rgid alpine-build@home-resources:/var/www/alpine-packages $rmount_packages
# umount : fusermount -u $rmount_packages

# prepare for abuild
sudo addgroup builder abuild
sudo mkdir -p /var/cache/distfiles
sudo chmod a+w /var/cache/distfiles
mkdir -p $home/.abuild
cp $rmount/abuild/* $home/.abuild

# prepare git repo
cd ~
git clone https://github.com/vincent-tr/rpi-image-builder

eof
