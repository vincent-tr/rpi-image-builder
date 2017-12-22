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
scp root@arch-desktop:/home/builder/raspberrypi/image-builder/abuild/* .abuild
```

# Install node from edge

```
wget http://dl-3.alpinelinux.org/alpine/edge/main/armhf/nodejs-npm-8.9.1-r0.apk
wget http://dl-3.alpinelinux.org/alpine/edge/main/armhf/libuv-1.17.0-r0.apk
wget http://dl-3.alpinelinux.org/alpine/edge/main/armhf/nodejs-8.9.1-r0.apk
apk add --allow-untrusted ./libuv-1.17.0-r0.apk
apk add --allow-untrusted ./nodejs-npm-8.9.1-r0.apk
apk add --allow-untrusted ./nodejs-8.9.1-r0.apk
apk del nodejs-npm
```

# Update alpine version

## Setup packages updates

```
setup-apkrepos
lbu commit -d
# edit
# change repo version
apk update
apk upgrade
reboot
```

## Setup kernel update

### prepare in /tmp
```
update-kernel -a armhf -f rpi2 /tmp
update-kernel -a armhf -f rpi /tmp
```

### install from local /tmp
```
mount -o remount,rw /media/mmcblk0p1/
cd /tmp
cp -r dtbs/* /media/mmcblk0p1/
cp * /media/mmcblk0p1/boot
# cp: omitting directory 'dtbs' => OK
reboot
```

### install from remote /tmp
```
mount -o remount,rw /media/mmcblk0p1/
scp -r root@rpi3-devel:/tmp/dtbs/* /media/mmcblk0p1/
scp root@rpi3-devel:/tmp/* /media/mmcblk0p1/boot
reboot

```

## References

https://wiki.alpinelinux.org/wiki/Upgrading_Alpine