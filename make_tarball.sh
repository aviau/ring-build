#!/bin/bash
currentdir=`pwd`
tmp=`mktemp -d`

cd $tmp

# Download
git clone --recursive https://gerrit-ring.savoirfairelinux.com/ring-project

# Update repositories
# TODO: remove this, ring-project should be up-to-date
cd $tmp/ring-project/daemon && git pull origin master
cd $tmp/ring-project/lrc && git pull origin master
cd $tmp/ring-project/client-gnome && git pull origin master

# Download contrib tarballs
cd $tmp/ring-project/daemon/contrib
mkdir native
cd native
../bootstrap
make fetch-all
cd ..
rm -rf native

# Create tarball
cd $tmp/ring-project
lastcommitdate=`git log -1 --format=%cd --date=short` # YYYY-MM-DD
numbercommits=`git log --format=%cd --date=short | grep -c $lastcommitdate` # number of commits that day
dateshort=`echo $lastcommitdate | sed -s 's/-//g'` # YYYYMMDD
commitid=`git rev-parse --short HEAD` # last commit id

cd $tmp
tar --exclude-vcs -zcf ring_$dateshort.$numbercommits.$commitid.tar.gz ring-project
rm -rf ring-project

# Move tarball to original dir
mv $tmp/*.tar.gz $currentdir
rm -rf $tmp
