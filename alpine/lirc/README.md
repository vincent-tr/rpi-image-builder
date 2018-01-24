sudo apk add libxslt python3 python3-dev bash linux-headers

cd /tmp
wget https://sourceforge.net/projects/lirc/files/LIRC/0.10.1/lirc-0.10.1.tar.gz
tar -zxvf lirc-0.10.1.tar.gz
mkdir build
mkdir pack
cd build
../lirc-0.10.1/configure --prefix=/usr --sysconfdir=/etc
make
make DESTDIR=/tmp/pack install