#!/bin/bash -e

if ! [ -x "$(command -v semver-cli)" ]; then
  CGO_ENABLED=0 go get -u github.com/davidrjonas/semver-cli
fi

