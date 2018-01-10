# alpine-nodejs-pm2

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
sudo apk add --no-cache --allow-untrusted ~/packages/nodejs-pm2-2.7.2-r0.apk
```
