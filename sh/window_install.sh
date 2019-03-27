#!/bin/sh

set -x -e

WINDOWS_TOOLCHAIN=i686-w64-mingw32
TOXCORE_PATH=${PWD}
TOXCORE_BUILD_PATH=${TOXCORE_PATH}/_build
TOXCORE_PREFIX_PATH=${TOXCORE_BUILD_PATH}/bin
LIBSODIUM_PATH=${TOXCORE_PATH}/third_party/libsodium
LIBSODIUM_PREFIX_PATH=${LIBSODIUM_PATH}/bin

cd ${LIBSODIUM_PATH}
./autogen.sh
./configure --host=${WINDOW_TOOL_CHAIN} --prefix=${LIBSODIUM_PREFIX_PATH} --enable-static
make 
sudo make install
make distclean
cd ${TOXCORE_PATH}

export MAKEFLAGS=j$(nproc)
export CFLAGS=-O3
export PKG_CONFIG_PATH="${LIBSODIUM_PREFIX_PATH}/lib/pkgconfig"

rm _build -rf
mkdir _build
cd _build
echo "
SET(CMAKE_SYSTEM_NAME  Windows)
SET(CMAKE_C_COMPILER   ${WINDOWS_TOOLCHAIN}-gcc)
SET(CMAKE_CXX_COMPILER ${WINDOWS_TOOLCHAIN}-g++)
SET(CMAKE_FIND_ROOT_PATH /usr/${WINDOWS_TOOLCHAIN} ${LIBSODIUM_PREFIX_PATH})
" > windows_toolchain.cmake

cmake -DCMAKE_TOOLCHAIN_FILE=windows_toolchain.cmake \
    -DAUTOTEST=OFF \
    -DCMAKE_INSTALL_PREFIX="${TOXCORE_PREFIX_PATH}" \
    -DENABLE_SHARED=OFF \
    -DENABLE_STATIC=ON \
    -DBOOSTRAP_DAEMON=OFF \
    -DBUILD_AV_TEST=OFF \
    -DDHT_BOOSTRAP=ON \
    -DBUILD_TOXAV=OFF \
    -DCMAKE_C_FLAGS="${CMAKE_C_FLAGS}" \
    -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS}" \
    -DCMAKE_EXE_LINKER_FLAGS="${CMAKE_EXE_LINKER_FLAGS}" \
    -DCMAKE_SHARED_LINKER_FLAGS="${CMAKE_SHARED_LINKER_FLAGS}" \
    -DCMAKE_GNUtoMS:BOOL=ON \
    ${EXTRA_CMAKE_FLAGS} \
    ..
    cmake --build . --target install -- -j${nproc}
    for archive in ${RESULT_PREFIX_DIR}/lib/libtox*.a
    do
        ${WINDOWS_TOOLCHAIN}-ar xv ${archive}
        echo "archive = ${archive}"
    done

    ${WINDOWS_TOOLCHAIN}-gcc -Wl,--export-all-symbols \
        -Wl,--out-implib=libtox.dll.a\
        -shared \
        -o libtox.dll \
        *.obj \
        ${TOXCORE_PREFIX_PATH}/lib/*.a \
        ${LIBSODIUM_PREFIX_PATH}/lib/*.a \
        /usr/${WINDOWS_TOOLCHAIN}/lib/libwinpthread.a \
        -liphlpapi \
        -lws2_32 \
        -static-libgcc
    mv libtox.dll ${TOXCORE_PREFIX_PATH}/lib
    mv ${TOXCORE_PREFIX_PATH} ${TOXCORE_PATH}
    rm ${TOXCORE_BUILD_PATH} -rf
    mkdir ${TOXCORE_BUILD_PATH} -p
    mv ${TOXCORE_PATH}/bin ${TOXCORE_PREFIX_PATH}
