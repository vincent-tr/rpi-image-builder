# Prepare env

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
