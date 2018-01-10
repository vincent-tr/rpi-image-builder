# alpine-mylife-home-inspircd-leaf-config

## Prepare

cf ../README.md

## Build package

```
su - builder
mkdir -p ~/packages
../abuild-package.sh $(basename $(pwd)) ~/packages inspircd
```

## Test package

```
# install inspircd, cf ../inspircd/README.md

# install package
sudo apk add --allow-untrusted ~/packages/alpine/armhf/mylife-home-inspircd-leaf-config-1.0.0-r0.apk

# install from arch-desktop
su -
scp root@arch-desktop:/home/builder/raspberrypi/image-builder/alpine-packages/noarch/mylife-home-inspircd-leaf-config-1.0.0-r0.apk .
apk add --allow-untrusted mylife-home-inspircd-leaf-config-1.0.0-r0.apk

# run daemon "by hand"
su - -s /bin/sh inspircd
/usr/bin/inspircd --config=/etc/inspircd/inspircd.conf
ps
cat /var/log/inspircd/startup.log
# stop it
kill -SIGTERM $(cat /var/run/inspircd/inspircd.pid)

# run daemon "normally"
rc-update add inspircd
rc-service inspircd start
```

## References:
 * https://github.com/thepaul/inspircd-deb/blob/master/debian/inspircd.init
 * https://wiki.alpinelinux.org/wiki/APKBUILD_examples:Simple
 * https://github.com/inspircd/inspircd-docker/blob/master/Dockerfile
 * https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=inspircd
 * https://github.com/kylef-archive/ark/tree/master/
