#!/bin/bash -e

#
# npm
#
curl https://nodejs.org/dist/v16.14.0/node-v16.14.0-linux-x64.tar.gz | tar xz

export PATH=$PATH:${PWD}/node-v16.14.0-linux-x64/bin

ls -lAhtr /usr/local/bin
echo $PATH
npm version
