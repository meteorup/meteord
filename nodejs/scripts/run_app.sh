set -e
echo 'Start Meteorup container.'
if [ -d /bundle ]; then
  echo 'Extract bundle file.'
  cd /bundle
  tar xzf *.tar.gz
elif [[ $BUNDLE_URL ]]; then
  echo 'Extract internet bundle.'
  cd /tmp
  curl -L -o bundle.tar.gz $BUNDLE_URL
  tar xzf bundle.tar.gz
else
  echo "=> You don't have an meteor app to run in this image."
  exit 1
fi
echo 'Detection of nodejs version'
[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh"
METEOR_VERSION=`grep meteorRelease bundle/star.json | awk '{print $2}'|sed -e 's/\"METEOR@\(.*\)\"/\1/g'|awk -F'.' '{print $2}'`
if [ "$METEOR_VERSION"x = "4"x ];then
  nvm use 4.4.7
elif [ "$METEOR_VERSION"x = "3"x ]; then
  nvm use 0.10.41
elif [ "$METEOR_VERSION"x = "2"x ]; then
  nvm use 0.10.40
elif [ "$METEOR_VERSION"x = "0"x ]; then
  nvm use 0.10.33
fi

if [[ $NODE_VERSION ]]; then
  echo 'Install node version to $NODE_VERSION'
  nvm install $NODE_VERSION
  nvm use $NODE_VERSION
fi

grep meteorRelease bundle/star.json | awk '{print $2}'|sed -e 's/\"METEOR@\(.*\)\"/\1/g' 
node -v

cd bundle/programs/server/

if [[ ! $SHRINKWRAP ]]; then
  echo 'process npm-shrinkwrap.json'
  sed -i 's/"resolved.*,/"!!":"",/g' npm-shrinkwrap.json
  sed -i 's/"resolved.*"/"!!":""/g' npm-shrinkwrap.json
fi

shopt -s expand_aliases
echo 'npm install.'
if [[ $NPM_DEFAULT ]]; then
  if [[ $NPM_DEBUG ]]; then
    alias cnpm="npm --loglevel verbose"
  else
    alias cnpm="npm"
  fi
else
  if [[ $NPM_DEBUG ]]; then
    alias cnpm="npm --loglevel verbose --registry=https://registry.npm.taobao.org --cache=$HOME/.npm/.cache/cnpm --disturl=https://npm.taobao.org/dist --userconfig=$HOME/.cnpmrc"
  else
    alias cnpm="npm --registry=https://registry.npm.taobao.org --cache=$HOME/.npm/.cache/cnpm --disturl=https://npm.taobao.org/dist --userconfig=$HOME/.cnpmrc"
  fi
fi

cnpm install
echo 'npm install complete'
cd ../../

if [[ $REBUILD_NPM_MODULES ]]; then
  if [ -f /opt/meteord/rebuild_npm_modules.sh ]; then
    echo 'Rebuild npm modules'
    cnpm install -g node-gyp
    cd programs/server
    bash /opt/meteord/rebuild_npm_modules.sh
    cd ../../
  else
    echo "=> Use meteorhacks/meteord:bin-build for binary bulding."
    exit 1
  fi
fi

# Set a delay to wait to start meteor container
if [[ $DELAY ]]; then
  echo "Delaying startup for $DELAY seconds"
  sleep $DELAY
fi

# Honour already existing PORT setup
export PORT=${PORT:-80}
echo "=> Starting meteor app on port:$PORT"
node main.js

