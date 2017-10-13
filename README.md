# rpi-image-builder
Raspberry PI image builder

## Setup
```
mkdir sources
cd sources
wget --trust-server-names https://downloads.raspberrypi.org/raspbian_lite_latest
wget --trust-server-names https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/kernel-qemu-4.4.34-jessie
cd ..
mkdir build-xx
cd build-xx
unzip ../sources/2017-09-07-raspbian-stretch-lite.zip
mv 2017-09-07-raspbian-stretch-lite.img target.img
ln -s ../sources/kernel-qemu-4.4.34-jessie kernel-qemu
mkdir mnt
sudo mount -v -o offset=48234496 -t ext4 target.img mnt
...
sudo umount mnt

qemu-system-arm -kernel kernel-qemu \
                  -cpu arm1176 \
                  -m 256 \
                  -M versatilepb \
                  -no-reboot \
                  -vnc :0 \
                  -serial stdio \
                  -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw init=/bin/bash" \
                  -d guest_errors \
                  -drive format=raw,file=target.img
```

## References94208
* qemu
  * https://azeria-labs.com/emulate-raspberry-pi-with-qemu/
  * https://blog.agchapman.com/using-qemu-to-emulate-a-raspberry-pi/
  * https://github.com/dhruvvyas90/qemu-rpi-kernel/wiki
  * https://github.com/dhruvvyas90/qemu-rpi-kernel/wiki/Emulating-Jessie-image-with-4.x.xx-kernel
* config
  * https://elinux.org/RPiconfig#Network
