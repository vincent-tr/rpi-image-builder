#!/bin/sh

# packages
apk add --no-cache --virtual .build-utils alpine-sdk

# prepare for abuild
sudo -i -u builder /bin/sh - << eof

sudo addgroup builder abuild
sudo mkdir -p /var/cache/distfiles
sudo chmod a+w /var/cache/distfiles
mkdir -p $home/.abuild
cp $rmount_build/abuild/* $home/.abuild

eof
