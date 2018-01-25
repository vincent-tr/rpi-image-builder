#!/bin/sh

if [ -z "$1" ]
then
  flavor=
else
  flavor=-$1
fi

script=$(readlink -f "$0")
base_dir=$(dirname $script)

echo "CONFIGURING FLAVOR : $flavor"

sed "s/{{flavor}}/$flavor/g" $base_dir/APKBUILD.template > $base_dir/APKBUILD
sed "s/{{flavor}}/$flavor/g" $base_dir/mylife-home-core.post-install.template > $base_dir/mylife-home-core$flavor.post-install
sed "s/{{flavor}}/$flavor/g" $base_dir/mylife-home-core.pre-deinstall.template > $base_dir/mylife-home-core$flavor.pre-deinstall
sed "s/{{flavor}}/$flavor/g" $base_dir/storage-service.initd.template > $base_dir/storage-service.initd
sed "s/{{flavor}}/$flavor/g" $base_dir/storage-service.sh.template > $base_dir/storage-service.sh
