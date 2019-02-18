#!/bin/bash

set -e

WORKSPACE=${PWD}
SRCDIR=${WORKSPACE}/sources/mvapich2
BINDIR=${WORKSPACE}/build/mvapich2

export CFLAGS="-I/opt/ddn/ime/include"
export LDFLAGS="-L/opt/ddn/ime/lib/ -lim_client"

rm -fr ${SRCDIR} ${BINDIR}

mkdir -p ${SRCDIR} || true
mkdir -p ${BINDIR} || true

git clone https://github.com/DDNStorage/mvapich2.git ${SRCDIR}
cd ${SRCDIR}
./autogen.sh
./configure --with-file-system=ime --prefix=${BINDIR} --disable-mcast
make -j 4
