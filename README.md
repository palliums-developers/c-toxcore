

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

## 清除
```sh
rm ./_build -R
rm ./third_party/libsodium -R
```
见./sh/window_uninstall.sh
## What is Tox

Tox is a peer to peer (serverless) instant messenger aimed at making security
and privacy easy to obtain for regular users. It uses
[NaCl](https://nacl.cr.yp.to/) for its encryption and authentication.

## IMPORTANT!

### ![Danger: Experimental](other/tox-warning.png)

This is an **experimental** cryptographic network library. It has not been
formally audited by an independent third party that specializes in
cryptography or cryptanalysis. **Use this library at your own risk.**

The underlying crypto library [NaCl](https://nacl.cr.yp.to/install.html)
provides reliable encryption, but the security model has not yet been fully
specified. See [issue 210](https://github.com/TokTok/c-toxcore/issues/210) for
a discussion on developing a threat model. See other issues for known
weaknesses (e.g. [issue 426](https://github.com/TokTok/c-toxcore/issues/426)
describes what can happen if your secret key is stolen).

## Toxcore Development Roadmap

The roadmap and changelog are generated from GitHub issues. You may view them
on the website, where they are updated at least once every 24 hours:

-   Changelog: https://toktok.ltd/changelog/c-toxcore
-   Roadmap: https://toktok.ltd/roadmap/c-toxcore

## Installing toxcore

Detailed installation instructions can be found in [INSTALL.md](INSTALL.md).

In a nutshell, if you have [libsodium](https://github.com/jedisct1/libsodium)
installed, run:

```sh
mkdir _build && cd _build
cmake ..
make
sudo make install
```

If you have [libvpx](https://github.com/webmproject/libvpx) and
[opus](https://github.com/xiph/opus) installed, the above will also build the
A/V library for multimedia chats.

## Using toxcore

The simplest "hello world" example could be an echo bot. Here we will walk
through the implementation of a simple bot.

### Creating the tox instance

All toxcore API functions work with error parameters. They are enums with one
`OK` value and several error codes that describe the different situations in
which the function might fail.

```c
TOX_ERR_NEW err_new;
Tox *tox = tox_new(NULL, &err_new);
if (err_new != TOX_ERR_NEW_OK) {
  fprintf(stderr, "tox_new failed with error code %d\n", err_new);
  exit(1);
}
```

Here, we simply exit the program, but in a real client you will probably want
to do some error handling and proper error reporting to the user. The `NULL`
argument given to the first parameter of `tox_new` is the `Tox_Options`. It
contains various write-once network settings and allows you to load a
previously serialised instance. See [toxcore/tox.h](tox.h) for details.

### Setting up callbacks

Toxcore works with callbacks that you can register to listen for certain
events. Examples of such events are "friend request received" or "friend sent
a message". Search the API for `tox_callback_*` to find all of them.

Here, we will set up callbacks for receiving friend requests and receiving
messages. We will always accept any friend request (because we're a bot), and
when we receive a message, we send it back to the sender.

```c
tox_callback_friend_request(tox, handle_friend_request);
tox_callback_friend_message(tox, handle_friend_message);
```

These two function calls set up the callbacks. Now we also need to implement
these "handle" functions.

### Handle friend requests

```c
static void handle_friend_request(
  Tox *tox, const uint8_t *public_key, const uint8_t *message, size_t length,
  void *user_data) {
  // Accept the friend request:
  TOX_ERR_FRIEND_ADD err_friend_add;
  tox_friend_add_norequest(tox, public_key, &err_friend_add);
  if (err_friend_add != TOX_ERR_FRIEND_ADD_OK) {
    fprintf(stderr, "unable to add friend: %d\n", err_friend_add);
  }
}
```

The `tox_friend_add_norequest` function adds the friend without sending them a
friend request. Since we already got a friend request, this is the right thing
to do. If you wanted to send a friend request yourself, you would use
`tox_friend_add`, which has an extra parameter for the message.

### Handle messages

Now, when the friend sends us a message, we want to respond to them by sending
them the same message back. This will be our "echo".

```c
static void handle_friend_message(
  Tox *tox, uint32_t friend_number, TOX_MESSAGE_TYPE type,
  const uint8_t *message, size_t length,
  void *user_data) {
  TOX_ERR_FRIEND_SEND_MESSAGE err_send;
  tox_friend_send_message(tox, friend_number, type, message, length,
    &err_send);
  if (err_send != TOX_ERR_FRIEND_SEND_MESSAGE_OK) {
    fprintf(stderr, "unable to send message back to friend %d: %d\n",
      friend_number, err_send);
  }
}
```

That's it for the setup. Now we want to actually run the bot.

### Main event loop

Toxcore works with a main event loop function `tox_iterate` that you need to
call at a certain frequency dictated by `tox_iteration_interval`. This is a
polling function that receives new network messages and processes them.

```c
while (true) {
  usleep(1000 * tox_iteration_interval(tox));
  tox_iterate(tox, NULL);
}
```

That's it! Now you have a working echo bot. The only problem is that since Tox
works with public keys, and you can't really guess your bot's public key, you
can't add it as a friend in your client. For this, we need to call another API
function: `tox_self_get_address(tox, address)`. This will fill the 38 byte
friend address into the `address` buffer. You can then display that binary
string as hex and input it into your client. Writing a `bin2hex` function is
left as exercise for the reader.

We glossed over a lot of details, such as the user data which we passed to
`tox_iterate` (passing `NULL`), bootstrapping into an actual network (this bot
will work in the LAN, but not on an internet server) and the fact that we now
have no clean way of stopping the bot (`while (true)`). If you want to write a
real bot, you will probably want to read up on all the API functions. Consult
the API documentation in [toxcore/tox.h](toxcore/tox.h) for more information.

### Other resources

- [Another echo bot](https://wiki.tox.chat/developers/client_examples/echo_bot)
- [minitox](https://github.com/hqwrong/minitox) (A minimal tox client)
