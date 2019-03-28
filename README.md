

## ubuntu

## 工具
```sh
sudo apt-get install autoconf
sudo apt-get install cmake
```
## 安装
```sh
cd ./third_party/libsodium
./autogen.sh
./configure
make 
sudo make install
make clean
cd ../../

rm _build -f
mkdir _build
cd _build
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
     ..
make 
sudo make install 
```
见./sh/ubuntu_install.sh  

## 测试

```sh

```
## 卸载 

```sh
sudo rm -rf /usr/local/lib/libtoxcore* 
sudo rm -rf /usr/local/lib/libsodium*
sudo rm -rf /usr/local/include/sodium* 
sudo rm -rf /usr/local/include/tox*
```
见./sh/ubuntu_uninstall.sh


## window

## 工具
```sh
sudo apt-get install autoconf
sudo apt-get install cmake 
sudo apt-get install mingw32
```

## 编译
```sh
WINDOWS_TOOLCHAIN=i686-w64-mingw32
TOXCORE_PATH=${PWD}
TOXCORE_BUILD_PATH=${TOXCORE_PATH}/_build
TOXCORE_PREFIX_PATH=${TOXCORE_BUILD_PATH}/bin
LIBSODIUM_PATH=${TOXCORE_PATH}/third_party/
LIBSODIUM_BUILD_PATH=${LIBSODIUM_PATH}/libsodium
LIBSODIUM_PREFIX_PATH=${LIBSODIUM_BUILD_PATH}/bin

cd ${LIBSODIUM_PATH}
git clone  -b stable https://github.com/jedisct1/libsodium.git
cd ${LIBSODIUM_BUILD_PATH}
git checkout tags/1.0.3
./autogen.sh
./configure --host=${WINDOWS_TOOLCHAIN} --prefix=${LIBSODIUM_PREFIX_PATH} --enable-static
make 
sudo make install
cd ${TOXCORE_PATH}
export MAKEFLAGS=j$(nproc)
export CFLAGS=-O3
export PKG_CONFIG_PATH="${LIBSODIUM_PREFIX_PATH}/lib/pkgconfig"
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
mv libtox* ${TOXCORE_PREFIX_PATH}/lib
mv ${LIBSODIUM_PREFIX_PATH}/bin/* ${TOXCORE_PREFIX_PATH}/lib/
mv ${LIBSODIUM_PREFIX_PATH}/include/* ${TOXCORE_PREFIX_PATH}/include
mv ${LIBSODIUM_PREFIX_PATH}/lib/pkgconfig ${TOXCORE_PREFIX_PATH}/lib/pkgconfig
mv ${LIBSODIUM_PREFIX_PATH}/lib/* ${TOXCORE_PREFIX_PATH}/lib
mv ${TOXCORE_PREFIX_PATH} ${TOXCORE_PATH}
rm ${TOXCORE_BUILD_PATH} -rf
mkdir ${TOXCORE_BUILD_PATH} -p
mv ${TOXCORE_PATH}/bin ${TOXCORE_PREFIX_PATH}
``` 
见./sh/window_install.sh
生成文件在 _build文件夹

## 清除
```sh
rm ./_build -R
rm ./third_party/libsodium -R
```
见./sh/window_uninstall.sh


## MAC OS

## 工具
```sh
sudo curl -OL http://ftpmirror.gnu.org/autoconf/autoconf-latest.tar.gz
tar xzf autoconf-latest.tar.gz
cd autoconf-latest
sudo ./configure --prefix=/usr/local/autotools-bin
sudo make
sudo make install
export PATH=$PATH:/usr/local/autotools-bin/bin


sudo curl -OL http://ftpmirror.gnu.org/automake/automake-1.15.tar.gz
sudo tar xzf automake-1.15.tar.gz
cd automake-1.15
sudo ./configure --prefix=/usr/local/autotools-bin
sudo sudo make
sudo make install

sudo curl -OL http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz
sudo tar xzf libtool-2.4.6.tar.gz
cd libtool-2.4.6
sudo ./configure --prefix=/usr/local/autotools-bin
sudo make
sudo make install
```

## 安装
```sh
git clone -b stable git://github.com/jedisct1/libsodium.git
cd libsodium
git chekcout tags/1.0.3
./autogen.sh
./configure
make 
sudo make install
cd ..

./autogen.sh
./configure
make  
sudo make install
```
