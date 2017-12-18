```
# modules build
apk -p /tmp/root-fs add --initdb --no-scripts --update-cache alpine-base linux-rpi-dev linux-rpi2-dev --arch armhf --keys-dir /etc/apk/keys --repositories-file /etc/apk/repositories
# build modules
apk add git make gcc
mkdir -p /tmp/extra-rpi
mkdir -p /tmp/extra-rpi2
cd /tmp
git clone https://github.com/mylife-home/mylife-home-drivers-ac
make -C /tmp/root-fs/usr/src/linux-headers-4.9.65-0-rpi M=/tmp/mylife-home-drivers-ac/drivers modules
cp /tmp/mylife-home-drivers-ac/drivers/*.ko /tmp/extra-rpi
make -C /tmp/root-fs/usr/src/linux-headers-4.9.65-0-rpi M=/tmp/mylife-home-drivers-ac/drivers clean
make -C /tmp/root-fs/usr/src/linux-headers-4.9.65-0-rpi2 M=/tmp/mylife-home-drivers-ac/drivers modules
cp /tmp/mylife-home-drivers-ac/drivers/*.ko /tmp/extra-rpi2
make -C /tmp/root-fs/usr/src/linux-headers-4.9.65-0-rpi2 M=/tmp/mylife-home-drivers-ac/drivers clean
rm -rf /tmp/root-fs
rm -rf /tmp/mylife-home-drivers-ac

# modules dans /tmp/extra-rpi  /tmp/extra-rpi2

# modloops build
apk add squashfs-tools
# rpi1
mkdir -p /tmp/modloop-rpi
mkdir -p /tmp/new-modloop-rpi
mount /media/mmcblk0p1/boot/modloop-rpi /tmp/modloop-rpi -t squashfs -o loop
cp -r /tmp/modloop-rpi/* /tmp/new-modloop-rpi
umount /tmp/modloop-rpi
rmdir /tmp/modloop-rpi
mkdir -p /tmp/new-modloop-rpi/modules/4.9.65-0-rpi/extra
cp -r /tmp/extra-rpi/* /tmp/new-modloop-rpi/modules/4.9.65-0-rpi/extra
mkdir -p /tmp/root-fs
ln -s /tmp/new-modloop-rpi /tmp/root-fs/lib
depmod -a -b /tmp/root-fs 4.9.65-0-rpi
rm -rf /tmp/root-fs
mksquashfs /tmp/new-modloop-rpi /tmp/modloop-rpi.sqfs -comp xz -exit-on-error
rm -rf /tmp/new-modloop-rpi
# rpi2
mkdir -p /tmp/modloop-rpi2
mkdir -p /tmp/new-modloop-rpi2
mount /media/mmcblk0p1/boot/modloop-rpi2 /tmp/modloop-rpi2 -t squashfs -o loop
cp -r /tmp/modloop-rpi2/* /tmp/new-modloop-rpi2
umount /tmp/modloop-rpi2
rmdir /tmp/modloop-rpi2
mkdir -p /tmp/new-modloop-rpi2/modules/4.9.65-0-rpi2/extra
cp -r /tmp/extra-rpi2/* /tmp/new-modloop-rpi2/modules/4.9.65-0-rpi2/extra
mkdir -p /tmp/root-fs
ln -s /tmp/new-modloop-rpi2 /tmp/root-fs/lib
depmod -a -b /tmp/root-fs 4.9.65-0-rpi2
rm -rf /tmp/root-fs
mksquashfs /tmp/new-modloop-rpi2 /tmp/modloop-rpi2.sqfs -comp xz -exit-on-error
rm -rf /tmp/new-modloop-rpi2
#
apk del squashfs-tools

# TODO:
# modloops install
```
