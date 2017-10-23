# alpine-inspircd

## Build

```
BUILD_DIRECTORY=~
VERSION=v2.0.24
apk add --no-cache --virtual .build-utils gcc g++ make git pkgconfig perl \
       perl-net-ssleay perl-crypt-ssleay perl-lwp-protocol-https \
       perl-libwww wget && \
# Install all permanent packages as long-therm dependencies
    apk add --no-cache --virtual .dependencies libgcc libstdc++ && \
    mkdir -p $BUILD_DIRECTORY/src && \
    cd $BUILD_DIRECTORY/src && \
    # Clone the requested version
    git clone https://github.com/inspircd/inspircd.git inspircd --depth 1 -b $VERSION && \
    cd $BUILD_DIRECTORY/src/inspircd && \
    ./configure --disable-interactive --binary-dir=/usr/bin --module-dir=/usr/lib/inspircd --config-dir=/etc/inspircd --data-dir=/var/run --log-dir=/var/log && \
    # Run build multi-threaded
    make -j4 && \
    make install && \
    # Uninstall all unnecessary tools after build process
    apk del .build-utils
```

## TODO package for apk:
```
# deps : libgcc libstdc++

# Make sure the application is allowed to write to it's own direcotry for
# logging and generation of certificates

# Create a user to run inspircd later
adduser -u 10000 -h /inspircd/ -D -S inspircd && \

chown -R inspircd /inspircd/ && \
chown -R inspircd /conf/
```

## References:
 * https://github.com/inspircd/inspircd-docker/blob/master/Dockerfile