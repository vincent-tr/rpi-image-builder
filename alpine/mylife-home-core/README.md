# alpine-mylife-home-core

## Prepare

cf ../README.md

## Build package

```
su - builder
rm -f ~/packages/alpine/armhf/APKINDEX.tar.gz
git clone https://github.com/vincent-tr/rpi-image-builder
cd rpi-image-builder/alpine/mylife-home-core
# abuild checksum # no source -> no need for checksum
abuild -r

# move package on arch-desktop
# on builder@arch-desktop
scp root@<target>:/home/builder/packages/alpine/armhf/mylife-home-core-1.0.4-r0.apk /home/builder/raspberrypi/image-builder/alpine-packages/armhf
```

## Test package

```
# install package
sudo apk add --allow-untrusted ~/packages/alpine/armhf/mylife-home-core-1.0.4-r0.apk

# install from arch-desktop
su -
scp root@arch-desktop:/home/builder/raspberrypi/image-builder/alpine-packages/armhf/mylife-home-core-1.0.4-r0.apk .
apk add --allow-untrusted mylife-home-core-1.0.4-r0.apk

# run
su - -s /bin/sh mylife-home
pm2 start --name mylife-home-core mylife-home-core/bin/server.js
pm2 save

# TODO: data/components.json ?
# TODO: dump.pm2 with mylife-home-core inside ?
# => merge dump.pm2.part with dump.pm2, then "su -l mylife-home -c 'pm2 resurrect'" to reload it


# cleanup persistent data
mount -o remount,rw /media/mmcblk0p1
rm -rf /media/mmcblk0p1/mylife-home
mount -o remount,ro /media/mmcblk0p1
```
