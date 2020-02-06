#!/usr/bin/env sh

if [ -z "$VUE_APP_ICINGA_API_URL" ]
then
    export VUE_APP_ICINGA_API_URL=https://net.pupu.li/icinga-public/hacklabfi
    echo "WARNING: Defaulting to $VUE_APP_ICINGA_API_URL for data source. To use your own set VUE_APP_ICINGA_API_URL beforehand"
fi


# abort on errors
set -e

# build
yarn build

# and push
cd dist
git init
git add -A
git commit -m "deploy"
git push -f git@github.com:hacklab-fi/icinga-public-page.git master:gh-pages
cd -
