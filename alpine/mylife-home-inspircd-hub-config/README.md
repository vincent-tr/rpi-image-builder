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
# install package
sudo apk add --no-cache --allow-untrusted ~/packages/inspircd-2.0.24-r0.apk
sudo apk add --no-cache --allow-untrusted ~/packages/mylife-home-inspircd-leaf-config-1.0.0-r0.apk

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
