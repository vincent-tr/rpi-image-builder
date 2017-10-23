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
# ln -s ../sources/kernel-qemu-4.4.34-jessie kernel-qemu
mkdir mnt
# fdisk -l target.img
# sudo mount -v -o offset=$((94208*512)) -t ext4 target.img mnt
sudo mount -v -o offset=$((8192*512)) -t vfat target.img mnt
sudo touch mnt/ssh
sudo umount mnt
sudo mount -v -o offset=$((8192*512)),ro -t vfat target.img mnt
mkdir raspi-boot
cp -r mnt/* raspi-boot/
sudo umount mnt
# add 1GO to device size
dd if=/dev/zero bs=1M count=1024 >> target.img

qemu-system-arm \
  -M raspi2 \
  -kernel raspi-boot/kernel7.img \
  -dtb raspi-boot/bcm2709-rpi-2-b.dtb \
  -drive if=sd,format=raw,file=target.img \
  -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootfstype=ext4" \
  -no-reboot \
  -vnc :0 \
  -serial stdio

```

## References94208
* qemu
  * https://azeria-labs.com/emulate-raspberry-pi-with-qemu/
  * https://blog.agchapman.com/using-qemu-to-emulate-a-raspberry-pi/
  * https://github.com/dhruvvyas90/qemu-rpi-kernel/wiki
  * https://github.com/dhruvvyas90/qemu-rpi-kernel/wiki/Emulating-Jessie-image-with-4.x.xx-kernel
* config
  * https://elinux.org/RPiconfig#Network

qemu-img resize target.img 4G