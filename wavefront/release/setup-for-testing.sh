#!/bin/bash -e

#
# npm
#
if ! [ -x "$(command -v npm)" ]; then
  curl http://npmjs.org/install.sh | bash
fi

npm version
