#!/bin/bash
TOP=`pwd`
git clone --recursive https://github.com/savoirfairelinux/ring-project.git
cd $TOP/daemon && git pull origin master
cd $TOP/lrc && git pull origin master
cd $TOP/client-gnome && git pull origin master

cd $TOP
tar --exclude-vcs -zcvf ring_20170301.0.git5cc051d.tar.gz ring-project
rm -rf ring-project
