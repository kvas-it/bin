#!/bin/bash

set -xe

PYTHON_VERSIONS="3.9.0 3.8.6 3.7.9 3.6.12 3.5.10 2.7.18"

brew update
brew install openssl zlib sqlite3 readline xz bash-completion pyenv pyenv-virtualenv

if grep -q 'pyenv virtualenv-init' ~/.bashrc; then
    echo .bashrc already has pyenv init
else
    cat >>~/.bashrc <<END

# Added by pyenv install script.
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
END
fi

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

for version in $PYTHON_VERSIONS; do
    pyenv install -s $version
done

# Install PyPy using brew. Binary install via pyenv fails and source install is
# complicated and takes forever.
brew install pypy3

EXISTING=$(pyenv versions)

if echo "$EXISTING" | grep -q pypy; then
    echo PyPy virtualenv already exists
else
    pyenv virtualenv -p $(which pypy3) pypy
fi

if echo "$EXISTING" | grep -q tools; then
    echo Tools virtualenv already exists
else
    pyenv virtualenv 3.9.0 tools
    pyenv activate tools
    pip install tox
    pyenv deactivate
fi

pyenv global 3.9.0 tools pypy 2.7.18
