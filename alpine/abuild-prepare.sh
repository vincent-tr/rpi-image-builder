#!/bin/sh

# packages
apk add --no-cache --virtual .build-utils alpine-sdk

home=/home/builder
rmount_build=$home/alpine-build-home-resources

sudo -i -u builder /bin/sh - << eof

# prepare for abuild
sudo addgroup builder abuild
sudo mkdir -p /var/cache/distfiles
sudo chmod a+w /var/cache/distfiles
mkdir -p $home/.abuild
cp $rmount_build/abuild/* $home/.abuild

eof
