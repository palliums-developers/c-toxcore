cd ./third_party/libsodium
git checkout tags/1.0.3
make clean
./autogen
./configure
make 
sudo make install
cd ../../


mkdir _build
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
