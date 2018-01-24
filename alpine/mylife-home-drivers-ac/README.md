# alpine-mylife-home-drivers-ac

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
sudo apk add --no-cache --allow-untrusted ~/packages/mylife-home-drivers-ac-1.0.0-r0.apk
```
