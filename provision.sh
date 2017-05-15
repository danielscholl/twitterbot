#!/bin/bash
source exports.sh

if [[ $# -eq 0 ]] ; then
    echo 'No Azure Site Specified'
    exit 1
fi

JOB_DIR='wwwroot/App_Data/jobs/continuous/twitterbot'

: ${DEPLOY_USER?"Need to set DEPLOY_USER"}
: ${DEPLOY_PASSWORD?"Need to set DEPLOY_PASSWORD"}
: ${PREFIX?"Need to set PREFIX"}

repo="https://"
repo+=$DEPLOY_USER
repo+=":"
repo+=$DEPLOY_PASSWORD
repo+="@"
repo+=$PREFIX
repo+='-'
repo+=$1

if [ "$SLOT" ]; then
	repo+='-'
	repo+=$SLOT
fi

repo+='.scm.azurewebsites.net:443/'
repo+=$PREFIX
repo+='-'
repo+=$1
repo+='.git'

echo 'Cloning Repository: '  $repo

git clone $repo wwwroot

if [ -d $JOB_DIR ]; then
	rm -R $JOB_DIR/*
fi

mkdir -p $JOB_DIR

cp package.json $JOB_DIR
cp server.js $JOB_DIR
cd $JOB_DIR

npm install --production

git add -A
git commit -m "Code Shipped"

git push origin master