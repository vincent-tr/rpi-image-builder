#!/bin/sh

source_dir=$1
target_dir=$2

arch=$(apk --print-arch)

mkdir -p $target_dir/$arch
mkdir -p $target_dir/noarch

echo "copy $source_dir/APKINDEX.tar.gz to $target_dir/$arch"
cp $source_dir/APKINDEX.tar.gz $target_dir/$arch

for file in $source_dir/*.apk
do
  package_arch=$(tar -zxOf $file .PKGINFO | grep -oE "arch = (.*)" | sed 's/arch = //g')
  echo "copy $file to $target_dir/$package_arch"
  cp $file $target_dir/$package_arch
done
