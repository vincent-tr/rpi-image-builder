# alpine-nodejs-pm2

## Prepare

cf ../README.md

## Build package

```
su - builder
rm -f ~/packages/alpine/armhf/APKINDEX.tar.gz
git clone https://github.com/vincent-tr/rpi-image-builder
cd rpi-image-builder/alpine/nodejs-pm2
# abuild checksum # no source -> no need for checksum
abuild -r

# move package on arch-desktop
# on builder@arch-desktop
scp root@<target>:/home/builder/packages/alpine/armhf/nodejs-pm2-2.7.2-r0.apk /home/builder/raspberrypi/image-builder/alpine-packages/armhf
```

## Test package

```
# install package
sudo apk add --allow-untrusted ~/packages/alpine/armhf/nodejs-pm2-2.7.2-r0.apk

# install from arch-desktop
su -
scp root@arch-desktop:/home/builder/raspberrypi/image-builder/alpine-packages/armhf/nodejs-pm2-2.7.2-r0.apk .
apk add --allow-untrusted nodejs-pm2-2.7.2-r0.apk

# TODO
```
