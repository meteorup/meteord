set -e

[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh"

nvm use 0.10.33  ## 1.0.2
npm install -g node-gyp
node-gyp install 0.10.33

nvm install 0.10.40 ## v1.2
npm install -g node-gyp
node-gyp install 0.10.40

nvm install 0.10.41 ## v1.3
npm install -g node-gyp
node-gyp install 0.10.41

nvm install 4.4.7 ## v1.4
npm install -g node-gyp
node-gyp install 4.4.7