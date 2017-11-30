#!/bin/sh

plugin_name=$1
plugin_version=$2
plugin_dependencies=$3
build_dir="$plugin_name-$plugin_version"

rm -rf $build_dir
mkdir $build_dir
cd $build_dir
cp ../APKBUILD.template ./APKBUILD
sed -i "s/{{plugin-name}}/$plugin_name/g" APKBUILD
sed -i "s/{{plugin-version}}/$plugin_version/g" APKBUILD
sed -i "s/{{plugin-dependencies}}/$plugin_dependencies/g" APKBUILD
abuild -r