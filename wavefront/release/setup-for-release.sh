#!/bin/bash -e
#
# semver-cli
#
if ! [ -x "$(command -v semver-cli)" ]; then
  CGO_ENABLED=0 go get -u github.com/davidrjonas/semver-cli
fi

#
# jq
#
if ! [ -x "$(command -v jq)" ]; then
  curl -H "Authorization: token ${GITHUB_CREDS_PSW}" -L "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" > ./jq
  chmod +x ./jq
  sudo mv ./jq /usr/local/bin
fi

