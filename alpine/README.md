# Prepare env

root@rpi3-devel :
```
apk add --no-cache wget && wget https://raw.githubusercontent.com/vincent-tr/rpi-image-builder/master/alpine/setup-base.sh && chmod +x setup-base.sh && ./setup-base.sh
```

# Build all packages

## build

root@rpi3-devel :
```
/home/builder/rpi-image-builder/alpine/abuild-prepare.sh

su - builder
cd rpi-image-builder/alpine
mkdir -p ~/packages

# copy existing packages in case we don't want to compile them all
cp ~/alpine-packages-home-resources/armhf/*.apk ~/packages/
cp ~/alpine-packages-home-resources/noarch/*.apk ~/packages/

./abuild-package.sh inspircd ~/packages
./abuild-package.sh mylife-home-inspircd-leaf-config ~/packages inspircd

./abuild-package.sh nodejs-pm2 ~/packages
./abuild-package.sh mylife-home-pm2-config ~/packages nodejs-pm2

./mylife-home-core/configure.sh && ./abuild-package.sh mylife-home-core ~/packages nodejs-pm2,mylife-home-pm2-config
./mylife-home-core/configure.sh drivers && ./abuild-package.sh mylife-home-core ~/packages nodejs-pm2,mylife-home-pm2-config
./mylife-home-core/configure.sh vpanel && ./abuild-package.sh mylife-home-core ~/packages nodejs-pm2,mylife-home-pm2-config

./abuild-package.sh gpio-admin ~/packages
./abuild-package.sh mylife-home-drivers-ac ~/packages
./abuild-package.sh lirc ~/packages

./mylife-home-core-plugins/configure.sh hw-blaster && ./abuild-package.sh mylife-home-core-plugins ~/packages nodejs-pm2,mylife-home-pm2-config,mylife-home-core,pi-blaster
./mylife-home-core-plugins/configure.sh hw-lirc && ./abuild-package.sh mylife-home-core-plugins ~/packages nodejs-pm2,mylife-home-pm2-config,mylife-home-core,lirc
./mylife-home-core-plugins/configure.sh hw-sensors && ./abuild-package.sh mylife-home-core-plugins ~/packages nodejs-pm2,mylife-home-pm2-config,mylife-home-core
./mylife-home-core-plugins/configure.sh hw-sysfs && ./abuild-package.sh mylife-home-core-plugins ~/packages nodejs-pm2,mylife-home-pm2-config,mylife-home-core

./mylife-home-core-plugins/configure.sh ui-base && ./abuild-package.sh mylife-home-core-plugins ~/packages nodejs-pm2,mylife-home-pm2-config,mylife-home-core-vpanel
./mylife-home-core-plugins/configure.sh vpanel-base && ./abuild-package.sh mylife-home-core-plugins ~/packages nodejs-pm2,mylife-home-pm2-config,mylife-home-core-vpanel
./mylife-home-core-plugins/configure.sh vpanel-colors && ./abuild-package.sh mylife-home-core-plugins ~/packages nodejs-pm2,mylife-home-pm2-config,mylife-home-core-vpanel
./mylife-home-core-plugins/configure.sh vpanel-selectors && ./abuild-package.sh mylife-home-core-plugins ~/packages nodejs-pm2,mylife-home-pm2-config,mylife-home-core-vpanel
./mylife-home-core-plugins/configure.sh vpanel-timers && ./abuild-package.sh mylife-home-core-plugins ~/packages nodejs-pm2,mylife-home-pm2-config,mylife-home-core-vpanel

./mylife-home-core-plugins/configure.sh hw-absoluta && ./abuild-package.sh mylife-home-core-plugins ~/packages nodejs-pm2,mylife-home-pm2-config,mylife-home-core-drivers
./mylife-home-core-plugins/configure.sh hw-arduino-home && ./abuild-package.sh mylife-home-core-plugins ~/packages nodejs-pm2,mylife-home-pm2-config,mylife-home-core-drivers
./mylife-home-core-plugins/configure.sh hw-broadlink && ./abuild-package.sh mylife-home-core-plugins ~/packages nodejs-pm2,mylife-home-pm2-config,mylife-home-core-drivers
./mylife-home-core-plugins/configure.sh hw-mpd && ./abuild-package.sh mylife-home-core-plugins ~/packages nodejs-pm2,mylife-home-pm2-config,mylife-home-core-drivers
./mylife-home-core-plugins/configure.sh hw-tahoma && ./abuild-package.sh mylife-home-core-plugins ~/packages nodejs-pm2,mylife-home-pm2-config,mylife-home-core-drivers

apk index -o ~/packages/APKINDEX.tar.gz ~/packages/*.apk
abuild-sign -k ~/.abuild/builder-59f0368c.rsa ~/packages/APKINDEX.tar.gz

# copy on home-resources
./abuild-deploy.sh ~/packages ~/alpine-packages-home-resources

# cleanup
rm -rf ~/packages
```

## test

root@rpi3-devel :
```
cp ~/.abuild/builder-59f0368c.rsa.pub /etc/apk/keys
sh -c "echo http://home-resources/alpine-packages >> /etc/apk/repositories"
apk update
```

TODO:
 - pi-blaster (+plugin)

# Kernel package (base-kernel-xxx.tar.gz)

## build

root@rpi3-devel :
```
su - builder
cd rpi-image-builder/alpine

./package-kernel.sh

# copy on home-resources
cp /tmp/base-kernel-*.tar.gz ~/alpine-build-home-resources/deploy-data/files

# cleanup
rm /tmp/base-kernel-*.tar.gz
```

# Config update (base-config.tar.gz)

root@rpi3-devel :
```
su - builder

sudo apk add --no-cache --virtual .build-utils tar
mkdir -p /tmp/update-config
cd /tmp/update-config

cp ~/alpine-build-home-resources/deploy-data/files/base-config.tar.gz .
tar -zxvf base-config.tar.gz
rm base-config.tar.gz
mkdir config
tar -C config -zxvf root/todo-hostname.apkovl.tar.gz
rm -r root
cd config

# DO UPDATES IN .

cd /tmp/update-config
mkdir root
cd config
tar --owner=root --group=root -zcvf ../root/todo-hostname.apkovl.tar.gz *
cd ..
rm -r config
tar --owner=root --group=root -zcvf base-config.tar.gz root
rm -r root
cp base-config.tar.gz ~/alpine-build-home-resources/deploy-data/files/

cd ~
rm -rf /tmp/update-config
sudo apk del .build-utils
```

# Install image

## on SD card

disk utility : format sd card as fat32 (label : alpine)
on local OSX:
```
scp root@home-resources:/home/alpine-build/deploy-data/files/image-xxx.tar.gz /tmp
tar -C /Volumes/ALPINE/ -zxvf /tmp/image-xxx.tar.gz
```

## on running alpine

```
scp root@home-resources:/home/alpine-build/deploy-data/files/image-rpi-devel-3.7.0-k4.9.65-0.tar.gz /tmp
mount -o remount,rw /media/mmcblk0p1/
rm -rf /media/mmcblk0p1/*
rm -rf /media/mmcblk0p1/.*
# will output :
# rm: can't remove '.' or '..'
# rm: can't remove '.' or '..'
# it can be ignored
tar -C /media/mmcblk0p1 -zxvf /tmp/image-rpi-devel-3.7.0-k4.9.65-0.tar.gz
reboot
```

## on running arch

ssh root@rpi-xxx
```
scp root@home-resources:/home/alpine-build/deploy-data/files/image-rpi-xxx-minimal.tar.gz /tmp/image.minimal.tar.gz
rm -rf /boot/*
rm -rf /boot/.*
# will output :
# rm: can't remove '.' or '..'
# rm: can't remove '.' or '..'
# it can be ignored
tar --no-same-owner -C /boot -zxvf /tmp/image.minimal.tar.gz
reboot
```

ssh root@rpi-xxx
```
umount /.modloop
umount /media/mmcblk0p1
# delete the 2 partitions
# create 1 partition primary with all space
# change its type to FAT32
fdisk /dev/mmcblk0
d
2
d
n
p
1


t
c
w
mkfs.vfat /dev/mmcblk0p1
mount -a
```

deploy from mylife-home-deploy

# old

cf old-procedure.md

## References

https://wiki.alpinelinux.org/wiki/Upgrading_Alpine
https://engineering.fundingcircle.com/blog/2015/04/28/create-alpine-linux-repository/