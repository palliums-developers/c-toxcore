#!/bin/bash

set -u -x -e

ORIGNAL_PATH=${PWD}
cd `dirname $0`
SH_PATH=${PWD}

INSTALL_PATH=${SH_PATH}/install/
LINUX_INSTALL_PATH=${INSTALL_PATH}/Linux/
WINDOWS_INSTALL_PATH=${INSTALL_PATH}/Windows/
ANDROID_INSTALL_PATH=${INSTALL_PATH}/Android/
MAC_INSTALL_PATH=${INSTALL_PATH}/MacOS/
IOS_INSTALL_PATH=${INSTALL_PATH}/IOS/
ANDROID_x86_INSTALL_PATH=${ANDROID_INSTALL_PATH}/x86/
ANDROID_x86_64_INSTALL_PATH=${ANDROID_INSTALL_PATH}/x86-64/
ANDROID_arm64_INSTALL_PATH=${ANDROID_INSTALL_PATH}/arm64-v8a/
ANDROID_armel_INSTALL_PATH=${ANDROID_INSTALL_PATH}/armeabi-v7a/
WINDOWS_x86_INSTALL_PATH=${WINDOWS_INSTALL_PATH}/x86/
WINDOWS_x86_64_INSTALL_PATH=${WINDOWS_INSTALL_PATH}/x86-64/

command -v wget > /dev/null || sudo apt-get install wget

if [ ! -d ${ANDROID_x86_INSTALL_PATH} ];then
    mkdir -p ${ANDROID_x86_INSTALL_PATH}
    wget https://build.tox.chat/job/tox4j_build_android_x86_release/lastSuccessfulBuild/artifact/artifacts/tox4j-c_2.11-0.1.2-SNAPSHOT.jar -P ${ANDROID_x86_INSTALL_PATH}
    wget https://build.tox.chat/job/tox4j_build_android_x86_release/lastSuccessfulBuild/artifact/artifacts/tox4j-c_2.11-0.1.2-SNAPSHOT-javadoc.jar -P ${ANDROID_x86_INSTALL_PATH}
    wget https://build.tox.chat/job/tox4j_build_android_x86_release/lastSuccessfulBuild/artifact/artifacts/tox4j-c_2.11-0.1.2-SNAPSHOT-sources.jar -P ${ANDROID_x86_INSTALL_PATH}
    wget https://build.tox.chat/job/tox4j_build_android_x86_release/lastSuccessfulBuild/artifact/artifacts/libtox4j-c.so -P ${ANDROID_x86_INSTALL_PATH}
fi
if [ ! -d ${ANDROID_x86_64_INSTALL_PATH} ];then
    mkdir -p ${ANDROID_x86_64_INSTALL_PATH}
    wget https://build.tox.chat/job/tox4j_build_android_x86-64_release/lastSuccessfulBuild/artifact/artifacts/tox4j-c_2.11-0.1.2-SNAPSHOT.jar -P ${ANDROID_x86_64_INSTALL_PATH}
    wget https://build.tox.chat/job/tox4j_build_android_x86-64_release/lastSuccessfulBuild/artifact/artifacts/tox4j-c_2.11-0.1.2-SNAPSHOT-javadoc.jar -P ${ANDROID_x86_64_INSTALL_PATH}
    wget https://build.tox.chat/job/tox4j_build_android_x86-64_release/lastSuccessfulBuild/artifact/artifacts/tox4j-c_2.11-0.1.2-SNAPSHOT-sources.jar -P ${ANDROID_x86_64_INSTALL_PATH}
    wget https://build.tox.chat/job/tox4j_build_android_x86-64_release/lastSuccessfulBuild/artifact/artifacts/libtox4j-c.so -P ${ANDROID_x86_64_INSTALL_PATH}
fi
if [ ! -d ${ANDROID_arm64_INSTALL_PATH} ];then
    mkdir -p ${ANDROID_arm64_INSTALL_PATH}
    wget https://build.tox.chat/job/tox4j_build_android_arm64_release/lastSuccessfulBuild/artifact/artifacts/tox4j-c_2.11-0.1.2-SNAPSHOT.jar -P ${ANDROID_arm64_INSTALL_PATH}
    wget https://build.tox.chat/job/tox4j_build_android_arm64_release/lastSuccessfulBuild/artifact/artifacts/tox4j-c_2.11-0.1.2-SNAPSHOT-javadoc.jar -P ${ANDROID_arm64_INSTALL_PATH}
    wget https://build.tox.chat/job/tox4j_build_android_arm64_release/lastSuccessfulBuild/artifact/artifacts/tox4j-c_2.11-0.1.2-SNAPSHOT-sources.jar -P ${ANDROID_arm64_INSTALL_PATH}
    wget https://build.tox.chat/job/tox4j_build_android_arm64_release/lastSuccessfulBuild/artifact/artifacts/libtox4j-c.so -P ${ANDROID_arm64_INSTALL_PATH}
fi
if [ ! -d ${ANDROID_armel_INSTALL_PATH} ];then
    mkdir -p ${ANDROID_armel_INSTALL_PATH}
    wget https://build.tox.chat/job/tox4j_build_android_armel_release/lastSuccessfulBuild/artifact/artifacts/tox4j-c_2.11-0.1.2-SNAPSHOT.jar -P ${ANDROID_armel_INSTALL_PATH}
    wget https://build.tox.chat/job/tox4j_build_android_armel_release/lastSuccessfulBuild/artifact/artifacts/tox4j-c_2.11-0.1.2-SNAPSHOT-javadoc.jar -P ${ANDROID_armel_INSTALL_PATH}
    wget https://build.tox.chat/job/tox4j_build_android_armel_release/lastSuccessfulBuild/artifact/artifacts/tox4j-c_2.11-0.1.2-SNAPSHOT-sources.jar -P ${ANDROID_armel_INSTALL_PATH}
    wget https://build.tox.chat/job/tox4j_build_android_armel_release/lastSuccessfulBuild/artifact/artifacts/libtox4j-c.so -P ${ANDROID_armel_INSTALL_PATH}
fi

test -e ${ANDROID_INSTALL_PATH}/tox4j-api_2.11-0.1.2.jar || wget https://build.tox.chat/job/tox4j-api_build_android_multiarch_release/lastSuccessfulBuild/artifact/tox4j-api/target/scala-2.11/tox4j-api_2.11-0.1.2.jar -P ${ANDROID_INSTALL_PATH}
#下载linux
test -d ${LINUX_INSTALL_PATH} || mkdir -p ${LINUX_INSTALL_PATH}
test -e ${LINUX_INSTALL_PATH}/libtoxcore-toktok_build_linux_x86_static_release.tar.xz ||  wget https://build.tox.chat/job/libtoxcore-toktok_build_linux_x86_static_release/lastSuccessfulBuild/artifact/libtoxcore-toktok_build_linux_x86_static_release.tar.xz -P ${LINUX_INSTALL_PATH}
test -e ${LINUX_INSTALL_PATH}/libtoxcore-toktok_build_linux_x86-64_static_release.tar.xz ||  wget https://build.tox.chat/job/libtoxcore-toktok_build_linux_x86-64_static_release/lastSuccessfulBuild/artifact/libtoxcore-toktok_build_linux_x86-64_static_release.tar.xz -P ${LINUX_INSTALL_PATH}
test -e ${LINUX_INSTALL_PATH}/libtoxcore-toktok_build_linux_x86-64_shared_release.tar.xz ||  wget https://build.tox.chat/job/libtoxcore-toktok_build_linux_x86-64_shared_release/lastSuccessfulBuild/artifact/libtoxcore-toktok_build_linux_x86-64_shared_release.tar.xz -P ${LINUX_INSTALL_PATH}
#下载windows
test -d ${WINDOWS_INSTALL_PATH} || mkdir -p ${WINDOWS_INSTALL_PATH}
test -e ${WINDOWS_INSTALL_PATH}/libtoxcore-toktok_build_windows_x86_shared_release.zip || wget https://build.tox.chat/job/libtoxcore-toktok_build_windows_x86_shared_release/lastSuccessfulBuild/artifact/libtoxcore-toktok_build_windows_x86_shared_release.zip -P ${WINDOWS_INSTALL_PATH}
test -e ${WINDOWS_INSTALL_PATH}/libtoxcore-toktok_build_windows_x86_static_release.zip || wget https://build.tox.chat/job/libtoxcore-toktok_build_windows_x86_static_release/lastSuccessfulBuild/artifact/libtoxcore-toktok_build_windows_x86_static_release.zip -P ${WINDOWS_INSTALL_PATH}
test -e ${WINDOWS_INSTALL_PATH}/libtoxcore-toktok_build_windows_x86-64_shared_release.zip || wget https://build.tox.chat/job/libtoxcore-toktok_build_windows_x86-64_shared_release/lastSuccessfulBuild/artifact/libtoxcore-toktok_build_windows_x86-64_shared_release.zip -P ${WINDOWS_INSTALL_PATH}
test -e ${WINDOWS_INSTALL_PATH}/libtoxcore-toktok_build_windows_x86-64_static_release.zip || wget https://build.tox.chat/job/libtoxcore-toktok_build_windows_x86-64_static_release/lastSuccessfulBuild/artifact/libtoxcore-toktok_build_windows_x86-64_static_release.zip -P ${WINDOWS_INSTALL_PATH}
