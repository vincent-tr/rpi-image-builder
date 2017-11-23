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

# Install node LTS

```
wget http://dl-3.alpinelinux.org/alpine/edge/main/armhf/nodejs-npm-8.9.1-r0.apk
wget http://dl-3.alpinelinux.org/alpine/edge/main/armhf/libuv-1.15.0-r0.apk
wget http://dl-3.alpinelinux.org/alpine/edge/main/armhf/nodejs-8.9.1-r0.apk
apk add --allow-untrusted ./libuv-1.15.0-r0.apk
apk add --allow-untrusted ./nodejs-npm-8.9.1-r0.apk
apk add --allow-untrusted ./nodejs-8.9.1-r0.apk
apk del nodejs-npm
```