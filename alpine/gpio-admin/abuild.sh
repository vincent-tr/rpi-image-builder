#!/bin/sh

script=$(readlink -f "$0")
target_dir=$1
tmp_dir=/tmp/rpi-image-builder-output
abuild_subdir=$(basename $(dirname $(dirname $script)))

mkdir -p $tmp_dir
abuild checksum
abuild -r -P $tmp_dir

cp $tmp_dir/$abuild_subdir/armhf/*.apk $target_dir