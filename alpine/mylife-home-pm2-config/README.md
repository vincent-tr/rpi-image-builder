# alpine-mylife-home-pm2-config

## Prepare

cf ../README.md

## Build package

```
su - builder
rm -f ~/packages/alpine/noarch/APKINDEX.tar.gz
git clone https://github.com/vincent-tr/rpi-image-builder
cd rpi-image-builder/alpine/mylife-home-pm2-config
abuild checksum
abuild -r

# move package on arch-desktop
# on builder@arch-desktop
scp root@<target>:/home/builder/packages/alpine/armhf/mylife-home-pm2-config-1.0.0-r0.apk /home/builder/raspberrypi/image-builder/alpine-packages/noarch
```

## Test package

```
# install nodejs-pm2, cf ../nodejs-pm2/README.md

# install package
sudo apk add --allow-untrusted ~/packages/alpine/armhf/mylife-home-pm2-config-1.0.0-r0.apk

# install from arch-desktop
su -
scp root@arch-desktop:/home/builder/raspberrypi/image-builder/alpine-packages/noarch/mylife-home-pm2-config-1.0.0-r0.apk .
apk add --allow-untrusted noarch/mylife-home-pm2-config-1.0.0-r0.apk


# run daemon "normally"
rc-update add pm2
rc-service pm2 start
```
