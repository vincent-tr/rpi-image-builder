# alpine-inspircd

## Prepare env

```
apk add --no-cache --virtual .build-utils alpine-sdk
adduser -D builder
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
addgroup builder abuild
mkdir -p /var/cache/distfiles
chmod a+w /var/cache/distfiles
su - builder
# restore ~/.abuild
mkdir .abuild
# on builder@arch-desktop
cd ~/raspberrypi/image-builder/abuild
scp * root@<target>:/home/builder/.abuild
# on builder@<target>
sudo chown builder:builder .abuild/*
```

## Build package

```
su - builder
rm -f ~/packages/alpine/armhf/APKINDEX.tar.gz
sudo apk add --no-cache --virtual .inspircd-build pkgconfig perl perl-net-ssleay perl-crypt-ssleay perl-lwp-protocol-https perl-libwww
git clone https://github.com/vincent-tr/rpi-image-builder
cd rpi-image-builder/alpine/inspircd
abuild checksum
abuild -r

# move package on arch-desktop
# on builder@arch-desktop
scp root@<target>:/home/builder/packages/alpine/armhf/inspircd-2.0.24-r0.apk /home/builder/raspberrypi/image-builder/alpine-packages/armhf

## Test package

# remove build tools
sudo apk del .inspircd-build

# install package
sudo apk add --allow-untrusted ~/packages/alpine/armhf/inspircd-2.0.24-r0.apk

# install from arch-desktop
su -
scp root@arch-desktop:/home/builder/raspberrypi/image-builder/alpine-packages/armhf/inspircd-2.0.24-r0.apk .
apk add --allow-untrusted inspircd-2.0.24-r0.apk

# dl configs
cd /etc/inspircd
wget http://home-resources.mti-team2.dyndns.org/static/inspircd.conf.rpi2-home-epanel1
mv inspircd.conf.rpi2-home-epanel1 inspircd.conf
wget http://home-resources.mti-team2.dyndns.org/static/inspircd.motd
wget http://home-resources.mti-team2.dyndns.org/static/inspircd.rules

# modifs configs :
changement pid : /var/run/inspircd/inspircd.pid
changenemt log : /var/log/inspircd/inspircd.log

# run daemon "by hand"
su - -s /bin/sh inspircd
/usr/bin/inspircd --config=/etc/inspircd/inspircd.conf
ps
cat /var/log/inspircd/startup.log
# stop it
kill -SIGTERM $(cat /var/run/inspircd/inspircd.pid)

# TODO: tester scripts init.d (pas possible dans docker)
```

## References:
 * https://github.com/thepaul/inspircd-deb/blob/master/debian/inspircd.init
 * https://wiki.alpinelinux.org/wiki/APKBUILD_examples:Simple
 * https://github.com/inspircd/inspircd-docker/blob/master/Dockerfile
 * https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=inspircd
 * https://github.com/kylef-archive/ark/tree/master/
