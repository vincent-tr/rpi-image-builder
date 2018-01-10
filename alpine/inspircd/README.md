# alpine-inspircd

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
sudo apk add --no-cache --allow-untrusted ~/packages/inspircd-2.0.24-r0.apk

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
