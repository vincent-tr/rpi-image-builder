#!/bin/sh

main() {

  # we need that to pick last kernel
  sudo apk update

  # package description : "linux-rpi-dev-4.9.65-r0 description:", kernel version : "4.9.65-0"
  version=$(apk info linux-rpi-dev | grep description | grep -oE "\d+\.\d+\.\d+\-r\d+" | sed 's/r//g')

  working_directory=/tmp/kernel-update
  output_dir=/tmp

  extra_dir=$working_directory/extra-modules
  kernel_dir=$working_directory/kernel

  build_modules
  # modules are in $extra_dir
  setup_kernel
  # kernel is in $kernel_dir
  build_modloop
  # modloops are built in-place in $kernel_dir
  package
}

build_modules() {
  echo "BUILDING MODULES"

  local working_root_fs=$working_directory/root-fs

  sudo apk add --no-cache --virtual .build-tools make gcc fakeroot

  mkdir -p $working_root_fs
  fakeroot apk -p $working_root_fs add --initdb --no-scripts --update-cache alpine-base linux-rpi-dev linux-rpi2-dev --arch armhf --keys-dir /etc/apk/keys --repositories-file /etc/apk/repositories

  mkdir -p $extra_dir/rpi
  mkdir -p $extra_dir/rpi2

  build_modules_mylife_home_drivers_ac $working_root_fs
  build_modules_mylife_home_drivers_pwm $working_root_fs

  rm -rf $working_root_fs
  sudo apk del .build-tools
}

build_modules_mylife_home_drivers_ac() {

  local src_dir=$working_directory/mylife-home-drivers-ac
  local working_root_fs=$1

  git clone https://github.com/mylife-home/mylife-home-drivers-ac $src_dir

  # rpi1
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi M=$src_dir/drivers modules
  cp $src_dir/drivers/*.ko $extra_dir/rpi
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi M=$src_dir/drivers clean

  # rpi2
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi2 M=$src_dir/drivers modules
  cp $src_dir/drivers/*.ko $extra_dir/rpi2
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi2 M=$src_dir/drivers clean

  # cleanup
  rm -rf $src_dir
}

build_modules_mylife_home_drivers_pwm() {

  local src_dir=$working_directory/mylife-home-drivers-pwm
  local working_root_fs=$1

  git clone https://github.com/mylife-home/mylife-home-drivers-pwm $src_dir

  # rpi1
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi M=$src_dir/drivers MYLIFE_ARCH=MYLIFE_ARCH_RPI1 modules
  cp $src_dir/drivers/*.ko $extra_dir/rpi
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi M=$src_dir/drivers clean

  # rpi2
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi2 M=$src_dir/drivers MYLIFE_ARCH=MYLIFE_ARCH_RPI2 modules
  cp $src_dir/drivers/*.ko $extra_dir/rpi2
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

  sudo apk add --no-cache --virtual .build-tools squashfs-tools

  build_modloop_by_flavor rpi
  build_modloop_by_flavor rpi2

  rm -rf $extra_dir
  sudo apk del .build-tools
}

build_modloop_by_flavor() {

  local flavor=$1
  local modloop_name=modloop-$flavor
  local working_root_fs=$working_directory/root-fs
  local full_version=$version-$flavor

  mkdir -p $working_directory/new-$modloop_name

  # pick existing modules
  mkdir -p $working_directory/$modloop_name
  sudo mount $kernel_dir/$modloop_name $working_directory/$modloop_name -t squashfs -o loop
  cp -r $working_directory/$modloop_name/* $working_directory/new-$modloop_name
  sudo umount $working_directory/$modloop_name
  rmdir $working_directory/$modloop_name
  rm -f $kernel_dir/$modloop_name

  # pick new modules
  mkdir -p $working_directory/new-$modloop_name/modules/$full_version/extra
  cp -r $extra_dir/$flavor/* $working_directory/new-$modloop_name/modules/$full_version/extra

  # build squashfs
  mkdir -p $working_root_fs
  ln -s $working_directory/new-$modloop_name $working_root_fs/lib
  depmod -a -b $working_root_fs $full_version
  rm -rf $working_root_fs
  mksquashfs $working_directory/new-$modloop_name $kernel_dir/$modloop_name -comp xz -exit-on-error -all-root
  rm -rf $working_directory/new-$modloop_name
}

package() {
  echo "PACKAGING"

  sudo apk add --no-cache --virtual .build-tools tar

  local root_fs=$working_directory/root

  mkdir -p $root_fs/boot
  cp -r $kernel_dir/dtbs/* $root_fs
  for flavor in rpi rpi2; do
    cp \
      $kernel_dir/System.map-$flavor \
      $kernel_dir/config-$flavor \
      $kernel_dir/initramfs-$flavor \
      $kernel_dir/modloop-$flavor \
      $kernel_dir/vmlinuz-$flavor \
      $root_fs/boot
  done

  tar --owner=root --group=root -C $working_directory -zcvf $output_dir/base-kernel-$version.tar.gz root

  rm -rf $working_directory
  sudo apk del .build-tools
}

main
