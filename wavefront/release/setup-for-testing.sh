#!/bin/bash -e

#
# npm
#
curl https://nodejs.org/dist/v16.14.0/node-v16.14.0-linux-arm64.tar.gz | tar xz
sudo rm /usr/local/bin/npm
sudo ln -s ${PWD}/node-v16.14.0-linux-arm64/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

ls -lAhtr /usr/local/bin
echo $PATH
/usr/local/bin/npm version
npm version
