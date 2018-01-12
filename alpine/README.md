# Prepare env

as root :
```
apk add --no-cache wget && wget https://raw.githubusercontent.com/vincent-tr/rpi-image-builder/master/alpine/setup-base.sh && chmod +x setup-base.sh && ./setup-base.sh
```

# Build all packages

## build

```
# as root :
/home/builder/rpi-image-builder/alpine/abuild-prepare.sh

su - builder
cd rpi-image-builder/alpine
mkdir -p ~/packages

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
rm -rf ~/alpine-packages-home-resources/alpine-packages/armhf
mkdir ~/alpine-packages-home-resources/alpine-packages/armhf
cp ~/packages/* ~/alpine-packages-home-resources/alpine-packages/armhf

# cleanup
rm -rf ~/packages
```

## test

```
sudo cp ~/.abuild/builder-59f0368c.rsa.pub /etc/apk/keys
sudo sh -c "echo http://home-resources/alpine-packages >> /etc/apk/repositories"
sudo apk update
```

TODO:
 - pi-blaster (+plugin)
 - lirc (+plugin)
 - sysfs ac drivers

# Kernel package

## build

```
su - builder
cd rpi-image-builder/alpine

./package-kernel.sh

# copy on home-resources
cp /tmp/kernel-*.tar.gz ~/alpine-build-home-resources/deploy-data/files

# cleanup
rm /tmp/kernel-*.tar.gz
```

# old

cf old-procedure.md

## References

https://wiki.alpinelinux.org/wiki/Upgrading_Alpine
https://engineering.fundingcircle.com/blog/2015/04/28/create-alpine-linux-repository/