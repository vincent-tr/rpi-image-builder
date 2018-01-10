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

# node-pm2
scp root@arch-desktop:/home/builder/raspberrypi/image-builder/alpine-packages/armhf/nodejs-pm2-2.7.2-r0.apk .
scp root@arch-desktop:/home/builder/raspberrypi/image-builder/alpine-packages/noarch/mylife-home-pm2-config-1.0.0-r0.apk .
apk add --allow-untrusted nodejs-pm2-2.7.2-r0.apk
apk add --allow-untrusted mylife-home-pm2-config-1.0.0-r0.apk

rc-update add pm2
rc-service pm2 start
```

## Build package

```
su - builder
mkdir -p ~/packages
../abuild-package.sh $(basename $(pwd)) ~/packages mylife-home-pm2-config
```

## Test package

```
# install package
sudo apk add --no-cache --allow-untrusted ~/packages/inspircd-2.0.24-r0.apk
sudo apk add --no-cache --allow-untrusted ~/packages/mylife-home-inspircd-leaf-config-1.0.0-r0.apk
sudo apk add --no-cache --allow-untrusted ~/packages/nodejs-pm2-2.7.2-r0.apk
sudo apk add --no-cache --allow-untrusted ~/packages/mylife-home-pm2-config-1.0.0-r0.apk
sudo apk add --no-cache --allow-untrusted ~/packages/mylife-home-core-1.0.5-r0.apk

# run
rc-update add inspircd
rc-service inspircd start
rc-update add pm2
rc-service pm2 start

rc-update add mylife-home-core-storage-service
rc-service mylife-home-core-storage-service start
su - -s /bin/sh mylife-home -c "pm2 resurrect"

# cleanup persistent data
mount -o remount,rw /media/mmcblk0p1
rm -rf /media/mmcblk0p1/mylife-home
mount -o remount,ro /media/mmcblk0p1
```
