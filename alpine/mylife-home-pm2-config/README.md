# alpine-mylife-home-pm2-config

## Prepare

cf ../README.md

## Build package

```
su - builder
mkdir -p ~/packages
../abuild-package.sh $(basename $(pwd)) ~/packages nodejs-pm2
```

## Test package

```
# install package
sudo apk add --no-cache --allow-untrusted ~/packages/nodejs-pm2-2.7.2-r0.apk
sudo apk add --no-cache --allow-untrusted ~/packages/mylife-home-pm2-config-1.0.0-r0.apk

# run daemon "normally"
rc-update add pm2
rc-service pm2 start
```
