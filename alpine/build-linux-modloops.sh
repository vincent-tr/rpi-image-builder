#!/bin/sh

version=$(uname -r | grep -oE "\d+\.\d+\.\d+\-\d+")
extra_rpi_dir=/tmp/extra-rpi
extra_rpi2_dir=/tmp/extra-rpi2
output_dir=/tmp

build_modules_mylife_home_drivers_ac() {
  cd /tmp
  git clone https://github.com/mylife-home/mylife-home-drivers-ac

  # rpi1
  make -C /tmp/root-fs/usr/src/linux-headers-4.9.65-0-rpi M=/tmp/mylife-home-drivers-ac/drivers modules
  cp /tmp/mylife-home-drivers-ac/drivers/*.ko /tmp/extra-rpi
  make -C /tmp/root-fs/usr/src/linux-headers-4.9.65-0-rpi M=/tmp/mylife-home-drivers-ac/drivers clean

  # rpi2
  make -C /tmp/root-fs/usr/src/linux-headers-4.9.65-0-rpi2 M=/tmp/mylife-home-drivers-ac/drivers modules
  cp /tmp/mylife-home-drivers-ac/drivers/*.ko /tmp/extra-rpi2
  make -C /tmp/root-fs/usr/src/linux-headers-4.9.65-0-rpi2 M=/tmp/mylife-home-drivers-ac/drivers clean

  # cleanup
  rm -rf /tmp/mylife-home-drivers-ac
}

build_modules() {
  echo "BUILDING MODULES"

  apk add git make gcc
  apk -p /tmp/root-fs add --initdb --no-scripts --update-cache alpine-base linux-rpi-dev linux-rpi2-dev --arch armhf --keys-dir /etc/apk/keys --repositories-file /etc/apk/repositories

  mkdir -p /tmp/extra-rpi
  mkdir -p /tmp/extra-rpi2

  build_modules_mylife_home_drivers_ac

  rm -rf /tmp/root-fs
  apk del git make gcc
}

build_modloop() {
  echo "BUILDING MODLOOPS"

  # init
  apk add squashfs-tools

  # rpi1
  mkdir -p /tmp/modloop-rpi
  mkdir -p /tmp/new-modloop-rpi
  mount /media/mmcblk0p1/boot/modloop-rpi /tmp/modloop-rpi -t squashfs -o loop
  cp -r /tmp/modloop-rpi/* /tmp/new-modloop-rpi
  umount /tmp/modloop-rpi
  rmdir /tmp/modloop-rpi
  mkdir -p /tmp/new-modloop-rpi/modules/$version-rpi/extra
  cp -r $extra_rpi_dir/* /tmp/new-modloop-rpi/modules/$version-rpi/extra
  mkdir -p /tmp/root-fs
  ln -s /tmp/new-modloop-rpi /tmp/root-fs/lib
  depmod -a -b /tmp/root-fs $version-rpi
  rm -rf /tmp/root-fs
  mksquashfs /tmp/new-modloop-rpi $output_dir/modloop-rpi -comp xz -exit-on-error
  rm -rf /tmp/new-modloop-rpi

  # rpi2
  mkdir -p /tmp/modloop-rpi2
  mkdir -p /tmp/new-modloop-rpi2
  mount /media/mmcblk0p1/boot/modloop-rpi2 /tmp/modloop-rpi2 -t squashfs -o loop
  cp -r /tmp/modloop-rpi2/* /tmp/new-modloop-rpi2
  umount /tmp/modloop-rpi2
  rmdir /tmp/modloop-rpi2
  mkdir -p /tmp/new-modloop-rpi2/modules/$version-rpi2/extra
  cp -r $extra_rpi2_dir/* /tmp/new-modloop-rpi2/modules/$version-rpi2/extra
  mkdir -p /tmp/root-fs
  ln -s /tmp/new-modloop-rpi2 /tmp/root-fs/lib
  depmod -a -b /tmp/root-fs $version-rpi2
  rm -rf /tmp/root-fs
  mksquashfs /tmp/new-modloop-rpi2 $output_dir/modloop-rpi2 -comp xz -exit-on-error
  rm -rf /tmp/new-modloop-rpi2

  # cleanup
  apk del squashfs-tools
}

build_modules
# modules are in $extra_rpi_dir and $extra_rpi2_dir
build_modloop