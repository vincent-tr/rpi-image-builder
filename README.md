# rpi-image-builder
Raspberry PI image builder

## Setup (alpine)
```
mkdir sources
cd sources
wget --trust-server-names http://dl-cdn.alpinelinux.org/alpine/v3.6/releases/armhf/alpine-rpi-3.6.2-armhf.tar.gz
scp root@rpi-devel:/root/backup.tar.gz .
mv backup.tar.gz rpi-devel.tar.gz
cd ..
mkdir build-xx
cd build-xx
dd if=/dev/zero of=target.img bs=1M count=512
fdisk target.img <<EOF
n




t
b
a
w
EOF
sudo sudo losetup --partscan --show --find target.img
# see the loop used for target.img
sudo mkfs.vfat /dev/loop0p1
sudo mount -o uid=builder,gid=users /dev/loop0p1 mnt
cd mnt
tar -zxvf ../../sources/rpi-devel.tar.gz --transform 's,mmcblk0p1/,./,'
cd ..
# copy boot files
mkdir rpi-boot
tar -c --exclude='mnt/apks*' --exclude='mnt/cache*' --exclude='mnt/*.apkovl.tar.gz' mnt/* | tar -x --transform 's,mnt/,./,' -C rpi-boot
sudo umount mnt
sudo losetup -d /dev/loop0
qemu-system-arm \
  -M raspi2 \
  -kernel rpi-boot/boot/vmlinuz-rpi2 \
  -initrd rpi-boot/boot/initramfs-rpi2 \
  -dtb rpi-boot/bcm2709-rpi-2-b.dtb \
  -drive if=sd,format=raw,file=target.img \
  -append "earlyprintk loglevel=8 $(cat rpi-boot/cmdline.txt)" \
  -no-reboot \
  -vnc :0 \
  -serial stdio \
  -net nic -net user,hostfwd=tcp::10022-:22,hostfwd=tcp::10080-:80
```

## Setup (raspbian)
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