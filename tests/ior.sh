#!/bin/bash

set -e

WORKSPACE=${PWD}
SRCDIR=${WORKSPACE}/sources/ior
BINDIR=${WORKSPACE}/build/ior

MVAPICH=${WORKSPACE}/build/mvapich2

export CFLAGS="-I/opt/ddn/ime/include"
export LDFLAGS="-L/opt/ddn/ime/lib/ -lim_client"
export LD_LIBRARY_PATH=/opt/ddn/ime/lib:$LD_LIBRARY_PATH

rm -fr ${SRCDIR} ${BINDIR}

mkdir -p ${SRCDIR} || true
mkdir -p ${BINDIR} || true

git clone https://github.com/hpc/ior.git ${SRCDIR}
cd ${SRCDIR}
./bootstrap
MPICC=${MVAPICH}/bin/mpicc ./configure --with-ime --prefix=${BINDIR}
make -j 4
make install

cd ${WORKSPACE}
${MVAPICH}/bin/mpirun -np 2 ${BINDIR}/bin/ior -a IME   -o testfile_ime
${MVAPICH}/bin/mpirun -np 2 ${BINDIR}/bin/ior -a MPIIO -o ime://testfile_mpiio
