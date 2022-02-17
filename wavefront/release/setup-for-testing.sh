#!/bin/bash -e

#
# npm
#
curl https://nodejs.org/dist/v16.14.0/node-v16.14.0-linux-arm64.tar.gz | tar xz
sudo ln -s /usr/local/bin/npm ${PWD}/node-v16.14.0-linux-arm64/lib/node_modules/npm/bin/npm-cli.js

ls -lAhtr /usr/local/bin
echo $PATH
/usr/local/bin/npm version
npm version
