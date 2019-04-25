#!/bin/bash

BIN=~/bin
BASE=`dirname $0`
BASE=`(cd $BASE; pwd)`

cd $BASE

for file in `ls`; do
    if [ ! -x $file ]; then
        continue
    fi
    if [ "setup.sh" == $file ]; then
        continue
    fi
    if [ -e $BIN/$file ]; then
        echo "Skipping $file -- it already exists in $BIN."
        continue
    fi
    ln -s $BASE/$file $BIN/$file
    echo "Linked $BASE/$file -> $BIN/$file"
done
