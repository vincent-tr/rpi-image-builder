# alpine-inspircd

## Prepare env

```
apk add --no-cache --virtual .build-utils alpine-sdk
adduser builder
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
addgroup builder abuild
mkdir -p /var/cache/distfiles
chmod a+w /var/cache/distfiles
su - builder
# restore ~/.abuild
```

## Build package

```
su - builder
sudo apk add --no-cache --virtual .inspircd-build pkgconfig perl perl-net-ssleay perl-crypt-ssleay perl-lwp-protocol-https perl-libwww
mkdir inspircd
cd inspircd
wget APKBUILD inspircd.* # TODO
abuild checksum
abuild -r

# remove build tools
sudo apk del .inspircd-build

# install package
sudo apk add --allow-untrusted ~/packages/builder/x86_64/inspircd-2.0.24-r0.apk

```

## References:
 * https://github.com/thepaul/inspircd-deb/blob/master/debian/inspircd.init
 * https://wiki.alpinelinux.org/wiki/APKBUILD_examples:Simple
 * https://github.com/inspircd/inspircd-docker/blob/master/Dockerfile
 * https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=inspircd
 * https://github.com/kylef-archive/ark/tree/master/inspircd