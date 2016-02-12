#!/bin/bash
# install a packages
apt-get update -y && apt-get install -y  gcc make git libjansson-dev libssh-dev libmysqlclient-dev  libmysqlclient18 libjansson4 libssh-4 strace valgrind
# add user pot this is user is the normale user (runnig the pot under root is too dangerous)
addgroup --gid 2000 pot 
adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 pot
# build the pot
mkdir -p /opt/dev
(cd /opt/dev
git clone https://github.com/jonaschl/SecureHoney.git 
(cd SecureHoney 
# insert the password into the config.h
sed -i s/"mysqlpassword"/"rpassword"/g config.h
sed -i s/"mysqlhost"/"192.168.101.251"/g config.h
cat config.h
chmod +x install.sh
./install.sh
))
# cleanup
apt-get remove -y git make gcc libjansson-dev libssh-dev libmysqlclient-dev
apt-get autoremove 
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /opt/dev/*

#lld /opt/securehoney/sshpot

# set permissions
chown -R pot:pot /opt
