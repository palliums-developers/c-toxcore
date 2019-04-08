#!/bin/bash

set -x -e -u
#到当前目录
ORIGINAL_DIR=${PWD}
cd `dirname $0`
#查看工具是否存在
command -v cmake > /dev/null || sudo apt-get install cmake=3.5.1-1ubuntu3
#查看库是否存在
ldconfig
if ! ldconfig -p | grep libsodium > /dev/null;then
    echo "start install libsodium"
    git clone -b stable https://github.com/jedisct1/libsodium.git
    cd libsodium
    command -v autoconf > /dev/null || sudo apt-get install autoconf
    ./autogen.sh
    make 
    sudo make install
    cd ..
    rm libsodium -R
fi
ldconfig -p | grep libtoxcore > /dev/null && echo >&2 "libtoxcore has already installed" && exit 1

#安装
test -d build &&  rm build -R
mkdir build
cd build
cmake \
    -DAUTOTEST=ON \
    -DBOOTSTRAP_DAEMON=OFF \
    -DBUILD_AV_TEST=OFF \
    -DBUILD_MISC_TESTS=OFF \
    -DBUILD_TOXAV=OFF \
    -DDHT_BOOTSTRAP=OFF \
    -DENABLE_SHARED=ON \
    -DENABLE_STATIC=ON \
    -DMIN_LOGGER_LEVEL=DEBUG \
    -DBUILD_MISC_TESTS=OFF \
    -DBUILD_MISC_TESTS=OFF \
    -DUSE_IPV6=ON \
    ../..
make 
#sudo make install

INSTALL_DIR=${PWD}/../ubuntu
test -d ${INSTALL_DIR} && rm ${INSTALL_DIR} -R 
sudo make install DESTDIR=${INSTALL_DIR} 
cd ..
mv ${INSTALL_DIR}/usr/local/* ${INSTALL_DIR}
rm ${INSTALL_DIR}/usr -R 
BIN_DIR=${INSTALL_DIR}/bin/
test -d ${BIN_DIR} && rm ${BIN_DIR} -R 
sudo mkdir ${BIN_DIR} -p
cp build/*test ${BIN_DIR}
rm build -R
cd ${ORIGINAL_DIR}
