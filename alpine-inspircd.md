# alpine-inspircd

## Build

```
BUILD_DIRECTORY=~
apk add --no-cache --virtual .build-utils gcc g++ make git pkgconfig perl \
       perl-net-ssleay perl-crypt-ssleay perl-lwp-protocol-https \
       perl-libwww wget gnutls-dev && \
# Install all permanent packages as long-therm dependencies
    apk add --no-cache --virtual .dependencies libgcc libstdc++ gnutls gnutls-utils && \
    mkdir -p $BUILD_DIRECTORY/src $BUILD_DIRECTORY/conf $BUILD_DIRECTORY/build && \
    cd $BUILD_DIRECTORY/src && \
    # Clone the requested version
    git clone https://github.com/inspircd/inspircd.git inspircd --depth 1 -b $VERSION && \
    cd $BUILD_DIRECTORY/src/inspircd && \
    # Add and overwrite modules
    { [ $(ls $BUILD_DIRECTORY/src/modules/ | wc -l) -gt 0 ] && cp -r $BUILD_DIRECTORY/src/modules/* $BUILD_DIRECTORY/src/inspircd/src/modules/ || echo "No modules overwritten/added by repository"; } && \
    # Enable GNUtls with SHA256 fingerprints
    ./configure --enable-extras=m_ssl_gnutls.cpp $CONFIGUREARGS && \
    ./configure --disable-interactive --prefix=$BUILD_DIRECTORY/build/ \
        --with-cc='c++ -DINSPIRCD_GNUTLS_ENABLE_SHA256_FINGERPRINT' && \
    # Run build multi-threaded
    make -j`getconf _NPROCESSORS_ONLN` && \
    make install && \
    # Uninstall all unnecessary tools after build process
    apk del .build-utils && \
    # Keep example configs as good reference for users
    cp -r $BUILD_DIRECTORY/build/conf/examples/ $BUILD_DIRECTORY/conf && \
    rm -rf $BUILD_DIRECTORY/src && \
    rm -rf $BUILD_DIRECTORY/build/conf
```

## TODO package for apk:
```
# deps : libgcc libstdc++ gnutls gnutls-utils

# Make sure the application is allowed to write to it's own direcotry for
# logging and generation of certificates

# Create a user to run inspircd later
adduser -u 10000 -h /inspircd/ -D -S inspircd && \

chown -R inspircd /inspircd/ && \
chown -R inspircd /conf/
```

## References:
 * https://github.com/inspircd/inspircd-docker/blob/master/Dockerfile