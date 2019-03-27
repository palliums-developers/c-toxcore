#!/bin/bash

set -u -e 
cd ./third_party/libsodium
./autogen.sh
./configure
make 
sudo make install
make clean
cd ../../

rm _build
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
