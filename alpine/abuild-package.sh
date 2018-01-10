#!/bin/sh

script=$(readlink -f "$0")
package=$1
target_dir=$2
dependencies=$3
tmp_dir=/tmp/rpi-image-builder-output
package_dir=$(dirname $script)/$package

if [[ ! -z "$dependencies" ]]; then
  depcl='';
  for dependency in $(echo $dependencies | sed "s/,/ /g")
  do
      # take last version
      depcl="$depcl $(ls -vr1 $target_dir/$dependency*.apk | head -1)"
  done

  sudo apk add --no-cache --allow-untrusted --virtual .dependencies-$package $depcl
fi


mkdir -p $tmp_dir

cd $package_dir
abuild checksum
abuild -r -P $tmp_dir

[[ ! -z "$dependencies" ]] && sudo apk del .dependencies-$package

cp $tmp_dir/alpine/armhf/*.apk $target_dir
rm -rf $tmp_dir
