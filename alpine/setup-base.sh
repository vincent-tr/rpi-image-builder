#!/bin/sh

# packages
apk add --no-cache --virtual .build-utils sudo sshfs git alpine-sdk

# create user
adduser -D builder
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

home=/home/builder
rmount=$home/alpine-build-home-resources

sudo -i -u builder /bin/sh - << eof

# add ssh key for alpine-build@home-resources
mkdir -p $home/.ssh
ssh-keyscan home-resources > $home/.ssh/known_hosts
scp -r root@home-resources:/home/alpine-build/ssh-keys/* $home/.ssh/
chmod 700 $home/.ssh

# add ssh mount
mkdir -p $rmount
sudo modprobe fuse
ruid=\$(ssh alpine-build@home-resources id -u)
rgid=\$(ssh alpine-build@home-resources id -g)
sshfs -o uid=\$ruid,gid=\$rgid alpine-build@home-resources:/home/alpine-build $rmount
# umount : fusermount -u $rmount

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
