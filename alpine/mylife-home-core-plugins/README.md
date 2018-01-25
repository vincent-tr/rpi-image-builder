# alpine-mylife-home-core

## Prepare

cf ../README.md


## Build package

```
su - builder
mkdir -p ~/packages

# drivers
./configure.sh hw-blaster
../abuild-package.sh $(basename $(pwd)) ~/packages pi-blaster
./configure.sh hw-lirc
../abuild-package.sh $(basename $(pwd)) ~/packages lirc
./configure.sh hw-sensors
../abuild-package.sh $(basename $(pwd)) ~/packages
./configure.sh hw-sysfs
../abuild-package.sh $(basename $(pwd)) ~/packages

# vpanel
./configure.sh ui-base
../abuild-package.sh $(basename $(pwd)) ~/packages
./configure.sh vpanel-base
../abuild-package.sh $(basename $(pwd)) ~/packages
./configure.sh vpanel-colors
../abuild-package.sh $(basename $(pwd)) ~/packages
./configure.sh vpanel-selectors
../abuild-package.sh $(basename $(pwd)) ~/packages
./configure.sh vpanel-timers
../abuild-package.sh $(basename $(pwd)) ~/packages

# core drivers
```

## Test package

```
# install package
sudo apk add --no-cache --allow-untrusted ~/packages/inspircd-2.0.24-r0.apk
sudo apk add --no-cache --allow-untrusted ~/packages/mylife-home-inspircd-leaf-config-1.0.0-r0.apk
sudo apk add --no-cache --allow-untrusted ~/packages/nodejs-pm2-2.7.2-r0.apk
sudo apk add --no-cache --allow-untrusted ~/packages/mylife-home-pm2-config-1.0.0-r0.apk
sudo apk add --no-cache --allow-untrusted ~/packages/mylife-home-core-1.0.5-r0.apk

# run
rc-update add inspircd
rc-service inspircd start
rc-update add pm2
rc-service pm2 start

rc-update add mylife-home-core-storage-service
rc-service mylife-home-core-storage-service start
su - -s /bin/sh mylife-home -c "pm2 resurrect"

sudo apk add --no-cache --allow-untrusted ~/packages/mylife-home-core-plugins-xxx.apk

#run: on irc /msg mylife-home-core_host plugin local load xxx
```
