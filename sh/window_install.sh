#!/bin/bash

set -e -x 

ORIGINAL_DIR=${PWD}
cd `dirname $0`
SH_PATH=${PWD}
WINDOWS_TOOLCHAIN=i686-w64-mingw32
TOOLCHAIN_PACKAGE=mingw32
TOXCORE_PREFIX_PATH=${SH_PATH}/build
TOXCORE_INSTALL_PATH=${SH_PATH}/${WINDOWS_TOOLCHAIN}
LIBSODIUM_INSTALL_PATH=${SH_PATH}/${WINDOWS_TOOLCHAIN}

command -v cmake > /dev/null || sudo apt-get install cmake
if ! command -v ${WINDOWS_TOOLCHAIN}-gcc > /dev/null;then
    sudo echo "deb http://us.archive.ubuntu.com/ubuntu trusty main universe" >> /etc/apt/sources.list
    sudo apt-get update
    sudp apt-get install ${TOOLCHAIN_PACKAGE}
fi
command -v autoconf > /dev/null || sudo apt-get install autoconf

test -d ${LIBSODIUM_INSTALL_PATH} && rm ${LIBSODIUM_INSTALL_PATH} -R
test -d libsodium && rm libsodium -R 
git clone -b stable git://github.com/jedisct1/libsodium
cd libsodium
git checkout tags/1.0.3
./autogen.sh
./configure --host=${WINDOWS_TOOLCHAIN} --prefix=${LIBSODIUM_INSTALL_PATH}  --enable-static
make 
make install
cd ..
rm -rf libsodium

test -d ${TOXCORE_PREFIX_PATH} && rm ${TOXCORE_PREFIX_PATH} -R
mkdir ${TOXCORE_PREFIX_PATH}
cd ${TOXCORE_PREFIX_PATH}

export PKG_CONFIG_PATH="${LIBSODIUM_INSTALL_PATH}/lib/pkgconfig"

echo "
SET(CMAKE_SYSTEM_NAME  Windows)
SET(CMAKE_C_COMPILER   ${WINDOWS_TOOLCHAIN}-gcc)
SET(CMAKE_CXX_COMPILER ${WINDOWS_TOOLCHAIN}-g++)
SET(CMAKE_RC_COMPILER  ${WINDOWS_TOOLCHAIN}-windres)
SET(CMAKE_FIND_ROOT_PATH /usr/${WINDOWS_TOOLCHAIN} ${LIBSODIUM_INSTALL_PATH})
" > windows_toolchain.cmake

export MAKEFLAGS=j$(nproc)
export CFLAGS=-O3

cmake -DCMAKE_TOOLCHAIN_FILE=windows_toolchain.cmake \
    -DAUTOTEST=ON \
    -DCMAKE_INSTALL_PREFIX="${TOXCORE_INSTALL_PATH}" \
    -DENABLE_SHARED=ON \
    -DENABLE_STATIC=ON \
    -DBOOSTRAP_DAEMON=OFF \
    -DBUILD_AV_TEST=OFF \
    -DDHT_BOOSTRAP=OFF \
    -DBUILD_TOXAV=OFF \
    -DBUILD_MISC_TESTS=OFF \
    -DMIN_LOGGER_LEVEL=DEBUG \
    -DBUILD_MISC_TESTS=OFF \
    -DUSE_IPV6=ON \
    ../..
cmake --build . --target install -- 
updatedb
PTHREADDLL_PATH=(`locate libwinpthread-1.dll | grep ${WINDOWS_TOOLCHAIN}`)
cp ${PTHREADDLL_PATH[0]} ${TOXCORE_INSTALL_PATH}/lib
SJLJDLL_PATH=(`locate libgcc_s_sjlj-1.dll | grep ${WINDOWS_TOOLCHAIN}`)
cp ${SJLJDLL_PATH[0]} ${TOXCORE_INSTALL_PATH}/lib
cp *.exe ${TOXCORE_INSTALL_PATH}/bin 
cd ${ORIGNAL_PATH}
rm ${TOXCORE_PREFIX_PATH} -rf
mv ${TOXCORE_INSTALL_PATH}/bin/*.dll ${TOXCORE_INSTALL_PATH}/lib
mv ${TOXCORE_INSTALL_PATH}/bin/*.def ${TOXCORE_INSTALL_PATH}/lib
