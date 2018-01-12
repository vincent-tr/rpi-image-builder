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
# edit
# change repo version
lbu commit -d
apk update
apk upgrade
reboot
```

## Setup kernel update

### prepare in /tmp

```
sudo apk add --no-cache --virtual .build-tools fakeroot
sudo update-kernel -a armhf -f rpi2 /tmp
sudo update-kernel -a armhf -f rpi /tmp
sudo apk del .build-tools
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