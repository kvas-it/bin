#!/bin/sh

BIN=~/bin
BASE=`dirname $0`
BASE=`(cd $BASE; pwd)`

contains() {
    if [[ $1 =~ $2 ]]; then
        return 0
    else
        return 1
    fi
}

EXCEPTIONS="setup.sh aaa"

cd $BASE

for file in `ls`; do
    if [ ! -x $file ]; then
        continue
    fi
    if contains "$EXCEPTIONS" $file; then
        continue
    fi
    if [ -e $BIN/$file ]; then
        echo "Skipping $file -- it already exists in $BIN."
        continue
    fi
    ln -s $BASE/$file $BIN/$file
    echo "Linked $BASE/$file -> $BIN/$file"
done
