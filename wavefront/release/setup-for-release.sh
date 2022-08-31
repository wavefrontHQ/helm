#!/bin/bash -ex

#
# jq
#
if ! [ -x "$(command -v jq)" ]; then
  curl -H "Authorization: token ${GITHUB_CREDS_PSW}" -L "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" > ./jq
  chmod +x ./jq
  sudo mv ./jq /usr/local/bin
fi

#
# yq
#
if ! [ -x "$(command -v yq)" ]; then
  curl -H "Authorization: token ${GITHUB_CREDS_PSW}" -L "https://github.com/mikefarah/yq/releases/download/v4.27.3/yq_linux_amd64" > ./yq
  chmod +x ./yq
  sudo mv ./yq /usr/local/bin
fi

#
# helm
#
curl https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz | tar xz --to-stdout linux-amd64/helm | sudo tee /usr/local/bin/helm >/dev/null
sudo chmod +x /usr/local/bin/helm