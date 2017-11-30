# alpine-mylife-home-core

## Prepare

cf ../README.md

```
# Install required packages

# inspircd
scp root@arch-desktop:/home/builder/raspberrypi/image-builder/alpine-packages/armhf/inspircd-2.0.24-r0.apk .
scp root@arch-desktop:/home/builder/raspberrypi/image-builder/alpine-packages/noarch/mylife-home-inspircd-leaf-config-1.0.0-r0.apk .
apk add --allow-untrusted inspircd-2.0.24-r0.apk
apk add --allow-untrusted mylife-home-inspircd-leaf-config-1.0.0-r0.apk

rc-update add inspircd
rc-service inspircd start

# node (follow ../README.md)
apk add --allow-untrusted ./nodejs-npm-8.9.1-r0.apk # if not already installed

# node-pm2/mylife-home-core
scp root@arch-desktop:/home/builder/raspberrypi/image-builder/alpine-packages/armhf/nodejs-pm2-2.7.2-r0.apk .
scp root@arch-desktop:/home/builder/raspberrypi/image-builder/alpine-packages/noarch/mylife-home-pm2-config-1.0.0-r0.apk .
scp root@arch-desktop:/home/builder/raspberrypi/image-builder/alpine-packages/noarch/mylife-home-core-1.0.5-r0.apk .
apk add --allow-untrusted nodejs-pm2-2.7.2-r0.apk
apk add --allow-untrusted mylife-home-pm2-config-1.0.0-r0.apk
apk add --allow-untrusted mylife-home-core-1.0.5-r0.apk

rc-update add mylife-home-core-storage-service # do not run for tests
rc-service mylife-home-core-storage-service start # do not run for tests

rc-update add pm2
rc-service pm2 start
```

## Build package

```
su - builder
rm -f ~/packages/alpine/armhf/APKINDEX.tar.gz
git clone https://github.com/vincent-tr/rpi-image-builder
cd rpi-image-builder/alpine/mylife-home-core-plugins

./build.sh plugin-name plugin-version plugin-dependencies

# move package on arch-desktop
# on builder@arch-desktop
scp root@<target>:/home/builder/packages/mylife-home-core-plugins/armhf/mylife-home-core-plugins-xxx-r0.apk /home/builder/raspberrypi/image-builder/alpine-packages/noarch
# or if it contains native binaries : find ./xxx -name '*.node'
scp root@<target>:/home/builder/packages/mylife-home-core-plugins/armhf/mylife-home-core-plugins-xxx-r0.apk /home/builder/raspberrypi/image-builder/alpine-packages/armhf
```

## Test package

```
# see required packages

# install package
sudo apk add --allow-untrusted ~/packages/mylife-home-core-plugins/armhf/mylife-home-core-plugins-xxx.apk

# install from arch-desktop
su -
scp root@arch-desktop:/home/builder/raspberrypi/image-builder/alpine-packages/noarch/mylife-home-core-plugins-xxx.apk .
# or
scp root@arch-desktop:/home/builder/raspberrypi/image-builder/alpine-packages/armhf/mylife-home-core-plugins-xxx.apk .
apk add --allow-untrusted mylife-home-core-plugins-xxx.apk

#run: on irc /msg mylife-home-core_host plugin local load xxx
```
