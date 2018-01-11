#!/bin/sh

# need :
# - $version
# - $extra_rpi_dir
# - $extra_rpi2_dir

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