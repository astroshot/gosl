#!/bin/bash

set -e

# find GOPATH
GP1="${GOPATH%:*}"
GP2="${GOPATH#*:}"
GP=$GP2
if [[ -z "${GP// }" ]]; then
    GP=$GP1
fi
GOSL="$GP/github.com/cpmech/gosl/"
echo "   GOPATH = $GP"
echo "   GOSL = $GOSL"

# find platform
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'MINGW32_NT-6.2' ]]; then
   platform='windows'
elif [[ "$unamestr" == 'MINGW64_NT-10.0' ]]; then
   platform='windows'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='darwin'
fi
echo "   platform = $platform"

# default flags (linux)
CFLAGS="-O2 -I/usr/include/suitesparse"
LDFLAGS="-L/usr/lib -lm -llapack -lgfortran -lblas \
-lumfpack -lamd -lcholmod -lcolamd -lsuitesparseconfig \
-ldmumps -lzmumps -lmumps_common -lpord"

# flags for each platform
if [[ $platform == 'windows' ]]; then
    CFLAGS="-O2 -I$GOSL/include"
    LDFLAGS="-L$GOSL/lib -lm -llapack -lgfortran -lblas \
    -lumfpack -lamd -lcholmod -lcolamd -lsuitesparseconfig"
elif [[ $platform == 'darwin' ]]; then
    CFLAGS="-O2 -I/usr/local"
    LDFLAGS="-L/usr/local/lib -lm -llapack -lgfortran -lblas \
    -lumfpack -lamd -lcholmod -lcolamd -lsuitesparseconfig"
fi

# write go file
FLAGS="xautogencgoflags.go"
echo "// Copyright 2016 The Gosl Authors. All rights reserved." > $FLAGS
echo "// Use of this source code is governed by a BSD-style" >> $FLAGS
echo "// license that can be found in the LICENSE file." >> $FLAGS
echo "" >> $FLAGS
echo "// *** NOTE: this file was auto generated by all.bash ***" >> $FLAGS
echo "// ***       and should be ignored                    ***" >> $FLAGS
echo "" >> $FLAGS
echo "package la" >> $FLAGS
echo "" >> $FLAGS
echo "/*" >> $FLAGS
echo "#cgo CFLAGS: $CFLAGS" >> $FLAGS
echo "#cgo LDFLAGS: $LDFLAGS" >> $FLAGS
echo "*/" >> $FLAGS
echo "import \"C\"" >> $FLAGS
