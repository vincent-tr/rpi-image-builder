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
sudo apk add --allow-untrusted ~/packages/gpio-admin-2.0.0-r0.apk
```
