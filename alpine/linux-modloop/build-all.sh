#!/bin/sh

version=$(uname -r | grep -oE "\d+\.\d+\.\d+\-\d+")
extra_rpi_dir=/tmp/extra-rpi
extra_rpi2_dir=/tmp/extra-rpi2
output_dir=/tmp

# prepare module build env
apk add git make gcc
apk -p /tmp/root-fs add --initdb --no-scripts --update-cache alpine-base linux-rpi-dev linux-rpi2-dev --arch armhf --keys-dir /etc/apk/keys --repositories-file /etc/apk/repositories

mkdir -p /tmp/extra-rpi
mkdir -p /tmp/extra-rpi2

# build modules
./build-mylife-home-drivers-ac.sh

# cleanup
rm -rf /tmp/root-fs
apk del git make gcc

# modules are in $extra_rpi_dir and $extra_rpi2_dir
# build modloops
./build-modloops.sh
