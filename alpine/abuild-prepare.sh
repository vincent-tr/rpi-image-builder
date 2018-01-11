#!/bin/sh

# packages
sudo apk add --no-cache --virtual .build-utils alpine-sdk

# prepare for abuild
sudo addgroup builder abuild
sudo mkdir -p /var/cache/distfiles
sudo chmod a+w /var/cache/distfiles
mkdir -p $HOME/.abuild
cp $HOME/alpine-build-home-resources/abuild/* $HOME/.abuild
