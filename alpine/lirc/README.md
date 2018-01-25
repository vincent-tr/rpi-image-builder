# alpine-lirc

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
sudo apk add --no-cache --allow-untrusted ~/packages/lirc-0.10.1-r0.apk

# run daemon "normally"
rc-update add lircd
rc-service lircd start
```