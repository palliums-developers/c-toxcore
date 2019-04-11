#! /bin/sh
set -e -x 

ORIGNAL_PATH=${PWD}

cd $(dirname "$0")
SH_PATH=${PWD}

if [ -z "$NDK_PLATFORM" ]; then
  export NDK_PLATFORM="android-16"
fi
export NDK_PLATFORM_COMPAT="${NDK_PLATFORM_COMPAT:-${NDK_PLATFORM}}"
export NDK_API_VERSION=$(echo "$NDK_PLATFORM" | sed 's/^android-//')
export NDK_API_VERSION_COMPAT=$(echo "$NDK_PLATFORM_COMPAT" | sed 's/^android-//')
export ANDROID_NDK_HOME=/opt/Android/Sdk/ndk-bundle/

if [ -z "$ANDROID_NDK_HOME" ]; then
  echo "You should probably set ANDROID_NDK_HOME to the directory containing"
  echo "the Android NDK"
  exit
fi

if [ "x$TARGET_ARCH" = 'x' ] || [ "x$ARCH" = 'x' ] || [ "x$HOST_COMPILER" = 'x' ]; then
  echo "You shouldn't use android-build.sh directly, use android-[arch].sh instead" >&2
  exit 1
fi

export MAKE_TOOLCHAIN="${ANDROID_NDK_HOME}/build/tools/make_standalone_toolchain.py"
export TOOLCHAIN_DIR="${SH_PATH}/android-toolchain-${TARGET_ARCH}"
export PATH="${PATH}:${TOOLCHAIN_DIR}/bin"
export CC=${CC:-"${HOST_COMPILER}-clang"}
export LIBSODIUM_INSTALL_PATH="${SH_PATH}/libsodium-android-${TARGET_ARCH}"
export TOXCORE_INSTALL_PATH="${SH_PATH}/toxcore-android-${TARGET_ARCH}"


if [ ! -d ${TOOLCHAIN_DIR} ];then
    env - PATH="$PATH" \
        "$MAKE_TOOLCHAIN" --force --api="$NDK_API_VERSION_COMPAT" \
        --arch="$ARCH" --install-dir="$TOOLCHAIN_DIR" || exit 1
fi

if [ ! -d ${LIBSODIUM_INSTALL_PATH} ];then
    test -d libsodium && rm libsodium  -rf
    git clone -b stable https://github.com/jedisct1/libsodium.git
    cd libsodium
    if [ -z "$LIBSODIUM_FULL_BUILD" ]; then
        export LIBSODIUM_ENABLE_MINIMAL_FLAG="--enable-minimal"
    else
        export LIBSODIUM_ENABLE_MINIMAL_FLAG=""
    fi

    ./configure \
        --disable-soname-versions \
        ${LIBSODIUM_ENABLE_MINIMAL_FLAG} \
        --host="${HOST_COMPILER}" \
        --prefix="${LIBSODIUM_INSTALL_PATH}" \
        --with-sysroot="${TOOLCHAIN_DIR}/sysroot" || exit 1
    make && make install
    cd .. && rm libsodium -rf
    echo "libsodium has been installed into ${LIBSODIUM_INSTALL_PATH}"
fi
    cp ${LIBSODIUM_INSTALL_PATH}/lib/libsodium* ${TOOLCHAIN_DIR}/sysroot/usr/lib
    test -d ${TOOLCHAIN_DIR}/sysroot/usr/local/lib || mkdir ${TOOLCHAIN_DIR}/sysroot/usr/local/lib
    cp ${LIBSODIUM_INSTALL_PATH}/lib/libsodium* ${TOOLCHAIN_DIR}/sysroot/usr/local/lib

if [ ! -d ${TOXCORE_INSTALL_PATH} ];then
    cd ..
    ./autogen.sh
    ./configure \
        --host="${HOST_COMPILER}" \
        --disable-av \
        --disable-tests \
        --enable-daemon=no \
        --enable-dht-bootstrap=no \
        --disable-rt \
        --disable-testing \
        --enable-epoll=no \
        --enable-static \
        --prefix="${TOXCORE_INSTALL_PATH}" \
        --with-sysroot="${TOOLCHAIN_DIR}/sysroot" || exit 1
    make clean 
    make install
    echo "toxcore has been installed into ${TOXCORE_INSTALL_PATH}"
fi
