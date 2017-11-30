#!/bin/sh

target_plugin=$1

while IFS=, read -r plugin_name plugin_version plugin_dependencies
do
  if ! [ -z "$target_plugin" ] && [ "$target_plugin" != "$plugin_name" ]
  then
    continue;
  fi
  echo "GENERATING PLUGIN : $plugin_name"
  ./build "$plugin_name" "$plugin_version" "$plugin_dependencies"
  echo "PLUGIN GENERATED : $plugin_name"
done < plugin-list