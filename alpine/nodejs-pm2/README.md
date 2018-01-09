# alpine-nodejs-pm2

## Prepare

cf ../README.md

## Build package

```
su - builder
mkdir -p ~/packages
../abuild-package.sh $(basename $(pwd)) ~/packages
```

## Test package

```
# install package
sudo apk add --allow-untrusted ~/packages/alpine/armhf/nodejs-pm2-2.7.2-r0.apk

# install from arch-desktop
su -
scp root@arch-desktop:/home/builder/raspberrypi/image-builder/alpine-packages/noarch/nodejs-pm2-2.7.2-r0.apk .
apk add --allow-untrusted nodejs-pm2-2.7.2-r0.apk
```
