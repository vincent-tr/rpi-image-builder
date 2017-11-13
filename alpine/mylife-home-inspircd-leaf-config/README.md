# alpine-mylife-home-inspircd-leaf-config

## Prepare

cf ../README.md

## Build package

```
su - builder
rm -f ~/packages/alpine/noarch/APKINDEX.tar.gz

git clone https://github.com/vincent-tr/rpi-image-builder
cd rpi-image-builder/alpine/mylife-home-inspircd-leaf-config
abuild checksum
abuild -r

# move package on arch-desktop
# on builder@arch-desktop
scp root@<target>:/home/builder/packages/alpine/armhf/mylife-home-inspircd-leaf-config-1.0.0-r0.apk /home/builder/raspberrypi/image-builder/alpine-packages/noarch
```

## Test package

```
# install inspircd, cf ../inspircd/README.md

# install package
sudo apk add --allow-untrusted ~/packages/alpine/armhf/mylife-home-inspircd-leaf-config-1.0.0-r0.apk

# install from arch-desktop
su -
scp root@arch-desktop:/home/builder/raspberrypi/image-builder/alpine-packages/noarch/mylife-home-inspircd-leaf-config-1.0.0-r0.apk .
apk add --allow-untrusted noarch/mylife-home-inspircd-leaf-config-1.0.0-r0.apk

# run daemon "by hand"
su - -s /bin/sh inspircd
/usr/bin/inspircd --config=/etc/inspircd/inspircd.conf
ps
cat /var/log/inspircd/startup.log
# stop it
kill -SIGTERM $(cat /var/run/inspircd/inspircd.pid)

# run daemon "normally"
rc-service inspircd start
```

## References:
 * https://github.com/thepaul/inspircd-deb/blob/master/debian/inspircd.init
 * https://wiki.alpinelinux.org/wiki/APKBUILD_examples:Simple
 * https://github.com/inspircd/inspircd-docker/blob/master/Dockerfile
 * https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=inspircd
 * https://github.com/kylef-archive/ark/tree/master/
