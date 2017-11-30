#!/bin/sh

plugin_name=$1
plugin_version=$2
plugin_noarch=$3
plugin_dependencies=$4
build_dir="$plugin_name-$plugin_version"

if [ "$plugin_noarch" == "yes" ]
then
  plugin_arch="noarch"
else
  plugin_arch="$(apk --print-arch)"
fi

rm -rf $build_dir
mkdir $build_dir
cd $build_dir
cp ../APKBUILD.template ./APKBUILD
sed -i "s/{{plugin-name}}/$plugin_name/g" APKBUILD
sed -i "s/{{plugin-version}}/$plugin_version/g" APKBUILD
sed -i "s/{{plugin-arch}}/$plugin_arch/g" APKBUILD
sed -i "s/{{plugin-dependencies}}/$plugin_dependencies/g" APKBUILD

echo "building $plugin_name-$plugin_version (arch=$plugin_arch, dependencies=$plugin_dependencies)"

abuild -r