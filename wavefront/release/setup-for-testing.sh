#!/bin/bash -e

#
# npm
#
curl https://nodejs.org/dist/v16.14.0/node-v16.14.0-linux-arm64.tar.gz | tar xz
sudo mv node-v16.14.0-linux-arm64/bin/npm /usr/local/bin/npm

npm version
