#!/bin/sh

# need :
# - $version
# - $extra_rpi_dir
# - $extra_rpi2_dir
# - $output_dir

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