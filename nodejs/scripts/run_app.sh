set -e

if [ -d /bundle ]; then
  cd /bundle
  tar xzf *.tar.gz
elif [[ $BUNDLE_URL ]]; then
  cd /tmp
  curl -L -o bundle.tar.gz $BUNDLE_URL
  tar xzf bundle.tar.gz
else
  echo "=> You don't have an meteor app to run in this image."
  exit 1
fi

[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh"
METEOR_VERSION=`grep meteorRelease bundle/star.json | awk '{print $2}'|sed -e 's/\"METEOR@\(.*\)\"/\1/g'`
if [ "$METEOR_VERSION"x = "1.4"x ];then
  nvm use 4.4.7
elif [ "$METEOR_VERSION"x = "1.3"x ]; then
  nvm use 0.10.41
elif [ "$METEOR_VERSION"x = "1.2"x ]; then
  nvm use 0.10.40
elif [ "$METEOR_VERSION"x = "1.0"x ]; then
  nvm use 0.10.33
fi

cd bundle/programs/server/
shopt -s expand_aliases
alias cnpm="npm --registry=https://registry.npm.taobao.org --cache=$HOME/.npm/.cache/cnpm --disturl=https://npm.taobao.org/dist --userconfig=$HOME/.cnpmrc"
cnpm i
cd ../../

if [[ $REBUILD_NPM_MODULES ]]; then
  if [ -f /opt/meteord/rebuild_npm_modules.sh ]; then
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
node -v
echo "=> Starting meteor app on port:$PORT"
node main.js

