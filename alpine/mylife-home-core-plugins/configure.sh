#!/bin/sh

target_plugin=$1

script=$(readlink -f "$0")
base_dir=$(dirname $script)

cat $base_dir/plugin-list | grep $target_plugin | \
while IFS=, read -r plugin_name plugin_version plugin_noarch plugin_dependencies
do
  echo "CONFIGURING PLUGIN : $plugin_name"

  if [ "$plugin_noarch" == "yes" ]
  then
    plugin_arch="noarch"
  else
    plugin_arch="$(apk --print-arch)"
  fi

  rm -f $base_dir/APKBUILD
  cp $base_dir/APKBUILD.template $base_dir/APKBUILD
  sed -i "s/{{plugin-name}}/$plugin_name/g" $base_dir/APKBUILD
  sed -i "s/{{plugin-version}}/$plugin_version/g" $base_dir/APKBUILD
  sed -i "s/{{plugin-arch}}/$plugin_arch/g" $base_dir/APKBUILD
  sed -i "s/{{plugin-dependencies}}/$plugin_dependencies/g" $base_dir/APKBUILD

  echo "configured $plugin_name-$plugin_version (arch=$plugin_arch, dependencies=$plugin_dependencies)"
done