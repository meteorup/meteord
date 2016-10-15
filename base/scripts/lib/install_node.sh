#!/bin/bash
set -e

# install nvm
curl -o- 'http://git.oschina.net/romejiang/nvm/raw/master/install.sh' | NVM_SOURCE='http://git.oschina.net/romejiang/nvm/raw/master' bash

[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh"

export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
export NVM_IOJS_ORG_MIRROR=http://npm.taobao.org/mirrors/iojs

nvm install 0.10.33  ## 1.0.2
nvm install 0.10.40 ## v1.2
nvm install 0.10.41 ## v1.3
nvm install 4.4.7 ## v1.4