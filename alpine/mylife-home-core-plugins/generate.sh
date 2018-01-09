#!/bin/sh

target_plugin=$1

while IFS=, read -r plugin_name plugin_version plugin_noarch plugin_dependencies
do
  if ! [ -z "$target_plugin" ] && [ "$target_plugin" != "$plugin_name" ]
  then
    continue;
  fi
  echo "GENERATING PLUGIN : $plugin_name"
  ./build-one.sh "$plugin_name" "$plugin_version" "$plugin_noarch" "$plugin_dependencies"
  echo "PLUGIN GENERATED : $plugin_name (noarch:$plugin_noarch)"
done < plugin-list