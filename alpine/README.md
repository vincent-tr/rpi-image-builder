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
./abuild-package.sh mylife-home-core ~/packages nodejs-pm2,mylife-home-pm2-config

./abuild-package.sh gpio-admin ~/packages

./mylife-home-core-plugins/configure.sh hw-blaster && ./abuild-package.sh mylife-home-core-plugins ~/packages nodejs-pm2,mylife-home-pm2-config,mylife-home-core,pi-blaster
./mylife-home-core-plugins/configure.sh hw-lirc && ./abuild-package.sh mylife-home-core-plugins ~/packages nodejs-pm2,mylife-home-pm2-config,mylife-home-core,lirc
./mylife-home-core-plugins/configure.sh hw-sensors && ./abuild-package.sh mylife-home-core-plugins ~/packages nodejs-pm2,mylife-home-pm2-config,mylife-home-core
./mylife-home-core-plugins/configure.sh hw-sysfs && ./abuild-package.sh mylife-home-core-plugins ~/packages nodejs-pm2,mylife-home-pm2-config,mylife-home-core

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
 - lirc (+plugin)
 - sysfs ac drivers

# Kernel package

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

# Config update

root@rpi3-devel :
```
su - builder

sudo apk add --no-cache --virtual .build-utils tar
mkdir -p /tmp/update-config
cd /tmp/update-config

cp ~/alpine-build-home-resources/deploy-data/files/base-config.tar.gz .
tar -zxvf base-config.tar.gz
rm base-config.tar.gz
tar -zxvf root/todo-hostname.apkovl.tar.gz
rm -r root

# DO UPDATES IN .

cd /tmp/update-config
mkdir root
tar --owner=root --group=root -zcvf root/todo-hostname.apkovl.tar.gz etc
rm -r etc
tar --owner=root --group=root -zcvf base-config.tar.gz root
rm -r root
cp base-config.tar.gz ~/alpine-build-home-resources/deploy-data/files/

cd ~
rm -rf /tmp/update-config
sudo apk del .build-utils
```

# Install image

## On SD card

TODO

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

TODO

# old

cf old-procedure.md

## References

https://wiki.alpinelinux.org/wiki/Upgrading_Alpine
https://engineering.fundingcircle.com/blog/2015/04/28/create-alpine-linux-repository/