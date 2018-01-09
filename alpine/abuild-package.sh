#!/bin/sh

script=$(readlink -f "$0")
package=$1
target_dir=$2
tmp_dir=/tmp/rpi-image-builder-output
package_dir=$(dirname $script)/$package

mkdir -p $tmp_dir

cd $package_dir
abuild checksum
abuild -r -P $tmp_dir

cp $tmp_dir/alpine/armhf/*.apk $target_dir
rm -rf $tmp_dir