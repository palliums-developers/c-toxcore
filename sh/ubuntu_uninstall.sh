#!/bin/bash
set -e -u -x
ldconfig
ldconfig -p | grep libtoxcore > /dev/null ||(echo >&2 "libtoxcore is uninstalled" ; exit 1)
INSTALL_DIR=/usr/local
rm ${INSTALL_DIR}/lib/libtox* -rf
rm ${INSTALL_DIR}/include/tox* -rf
