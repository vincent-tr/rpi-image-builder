#!/bin/sh

main() {

  # we need that to pick last kernel
  sudo apk update

  # package description : "linux-rpi-dev-4.9.65-r0 description:", kernel version : "4.9.65-0"
  version=$(apk info linux-rpi-dev | grep description | grep -oE "\d+\.\d+\.\d+\-r\d+" | sed 's/r//g')

  working_directory=/tmp/kernel-update
  output_dir=/tmp

  extra_rpi_dir=$working_directory/extra-rpi
  extra_rpi2_dir=$working_directory/extra-rpi2
  kernel_dir=$working_directory/kernel

  build_modules
  setup_kernel
  build_modloop
  package
}

build_modules() {
  echo "BUILDING MODULES"

  local working_root_fs=$working_directory/root-fs

  sudo apk add --no-cache --virtual .build-tools make gcc fakeroot

  mkdir -p $working_root_fs
  fakeroot apk -p $working_root_fs add --initdb --no-scripts --update-cache alpine-base linux-rpi-dev linux-rpi2-dev --arch armhf --keys-dir /etc/apk/keys --repositories-file /etc/apk/repositories

  mkdir -p $extra_rpi_dir
  mkdir -p $extra_rpi2_dir

  build_modules_mylife_home_drivers_ac $working_root_fs

  rm -rf $working_root_fs
  sudo apk del .build-tools
}

build_modules_mylife_home_drivers_ac() {
  local src_dir=$working_directory/mylife-home-drivers-ac
  local working_root_fs=$1

  git clone https://github.com/mylife-home/mylife-home-drivers-ac $src_dir

  # rpi1
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi M=$src_dir/drivers modules
  cp $src_dir/drivers/*.ko $extra_rpi_dir
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi M=$src_dir/drivers clean

  # rpi2
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi2 M=$src_dir/drivers modules
  cp $src_dir/drivers/*.ko $extra_rpi2_dir
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi2 M=$src_dir/drivers clean

  # cleanup
  rm -rf $src_dir
}

setup_kernel() {
  echo "SETUPING KERNEL"
  sudo apk add --no-cache --virtual .build-tools fakeroot

  sudo update-kernel -a armhf -f rpi2 $kernel_dir
  sudo update-kernel -a armhf -f rpi $kernel_dir

  sudo chown -R $(id -u -n):$(id -g -n) $kernel_dir

  sudo apk del .build-tools
}

build_modloop() {
  echo "BUILDING MODLOOPS"

  local working_root_fs=$working_directory/root-fs

  # init
  sudo apk add --no-cache --virtual .build-tools squashfs-tools

  build_modloop_by_name modloop-rpi
  build_modloop_by_name modloop-rpi2

  # cleanup
  sudo apk del .build-tools
}

build_modloop_by_name() {
  local modloop_name=$1
  local working_root_fs=$working_directory/root-fs

  mkdir -p $working_directory/new-$modloop_name

  # pick existing modules
  mkdir -p $working_directory/$modloop_name
  sudo mount $kernel_dir/$modloop_name $working_directory/$modloop_name -t squashfs -o loop
  cp -r $working_directory/$modloop_name/* $working_directory/new-$modloop_name
  sudo umount $working_directory/$modloop_name
  rmdir $working_directory/$modloop_name
  rm -f $kernel_dir/$modloop_name

  # pick new modules
  mkdir -p $working_directory/new-$modloop_name/modules/$version-rpi/extra
  cp -r $extra_rpi_dir/* $working_directory/new-$modloop_name/modules/$version-rpi/extra
  rm -rf $extra_rpi_dir

  # build squashfs
  mkdir -p $working_root_fs
  ln -s $working_directory/new-$modloop_name $working_root_fs/lib
  depmod -a -b $working_root_fs $version-rpi
  rm -rf $working_root_fs
  mksquashfs $working_directory/new-$modloop_name $output_dir/$modloop_name -comp xz -exit-on-error
  rm -rf $working_directory/new-$modloop_name
}

package() {
  echo TODO
}

main
