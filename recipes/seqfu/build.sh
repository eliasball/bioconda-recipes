#!/bin/sh

set -euxo pipefail

echo "--- NIM BUILD ---"
nim --version
echo "----------"



echo " Setting environment variables"
# Fix zlib
export CFLAGS="$CFLAGS -I$PREFIX/include"
export LDFLAGS="$LDFLAGS -L$PREFIX/lib"
export CPATH=${PREFIX}/include

echo "GXX: $GXX"
echo "GCC: $GCC"
echo "----------"
echo "Patching makefile"
# Trying to fix build when gcc or g++ are required
sed -i 's/gcc/$(GCC)/g' Makefile
sed -i 's/g++/$(GXX)/g' Makefile
sed -i '1iGCC ?= gcc' Makefile
sed -i '1iGXX ?= g++' Makefile

if [[ $OSTYPE == "darwin"* ]]; then
  export HOME="/Users/distiller"
  export HOME=`pwd`
fi

mkdir -p "$PREFIX"/bin

echo "## Automatic build: install deps"
#nimble build -y --verbose 
nimble install -y --depsOnly
echo "## Automatic build: make"
make

./bin/seqfu version || true


# Not necessary using `make`
#if [[ -d scripts ]]; then
#  echo "## Copying utils"
#  chmod +x scripts/*
#  cp scripts/* bin/
#fi

echo "## Current dir: $(pwd)"
mv bin/* "$PREFIX"/bin/


echo "## List files in \$PREFIX/bin:"
ls -ltr "$PREFIX"/bin/
 
