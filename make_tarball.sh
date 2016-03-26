#!/bin/bash
currentdir=`pwd`
tmp=`mktemp -d`

cd $tmp

# Download
git clone --recursive https://github.com/savoirfairelinux/ring-project.git

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
make fetch
cd ..
rm -rf native

# Create tarball
cd $tmp
tar --exclude-vcs -zcf ring_20170301.0.git5cc051d.tar.gz ring-project
rm -rf ring-project

# Move tarball to original dir
mv $tmp/*.tar.gz $currentdir
rm -rf $tmp
