#!/bin/bash
apt-get update -y &&  DEBIAN_FRONTEND=noninteractive apt-get install -y -y mariadb-server
mysqld_safe & mysqladmin --silent --wait=30 ping || exit 1
#/usr/sbin/mysqld_safe &&  sleep 5
#mysqladmin --silent --wait=30 ping || exit 1
echo 1
mysql -e "GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;"
echo 2
mysql -u root -e "CREATE USER 'honeyssh'@'%' IDENTIFIED BY 'rpassword';"
echo 3
mysql -u root -e "GRANT USAGE ON *.* TO 'honeyssh'@'%' IDENTIFIED BY 'rpassword' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;"
echo 4
mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`honeyssh\`;"
echo 5
mysql -u root -e "GRANT ALL PRIVILEGES ON \`honeyssh\`.* TO 'honeyssh'@'%';"
echo 6
mysql -u root -e "show databases"
echo 7
#mysql -u root -e use honeyssh;
mysql -u honeyssh -prpassword -D honeyssh -e "CREATE TABLE \`login\` (\`session-id\` bigint(20) unsigned NOT NULL, \`number\` int(11) NOT NULL, \`time\` datetime NOT NULL, \`user\` text NOT NULL, \`password\` text NOT NULL, \`action\` int(11) NOT NULL, \`id\` bigint(20) NOT NULL AUTO_INCREMENT, PRIMARY KEY (\`id\`)) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;"
echo 8
mysql -u honeyssh -prpassword -D honeyssh -e "CREATE TABLE \`command\` (\`session-id\` bigint(20) unsigned NOT NULL, \`number\` int(11) NOT NULL, \`time\` datetime NOT NULL, \`command\` text NOT NULL, \`action\` int(11) NOT NULL, \`id\` int(11) NOT NULL AUTO_INCREMENT, PRIMARY KEY (\`id\`)) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;"
echo 9
mysql -u honeyssh -prpassword -D honeyssh -e "CREATE TABLE \`connection\` (\`session-id\` bigint(20) unsigned NOT NULL, \`ip\` text NOT NULL, \`start-time\` datetime NOT NULL, \`end-time\` datetime NOT NULL, \`banner\` text NOT NULL, \`cipher-in\` text NOT NULL, \`cipher-out\` text NOT NULL, \`protocol-version\` text NOT NULL, \`openssh-version\` text NOT NULL, \`action\` int(11) NOT NULL, \`id\` bigint(11) NOT NULL AUTO_INCREMENT,  PRIMARY KEY (\`id\`)) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;"
echo 10
mysql -u honeyssh -prpassword -D honeyssh -e "INSERT INTO \`connection\` (\`session-id\`, \`ip\`, \`start-time\`, \`end-time\`, \`banner\`, \`cipher-in\`, \`cipher-out\`, \`protocol-version\`, \`openssh-version\`, \`action\`, \`id\`) VALUES ('0', 'base', '2016-01-01 00:00:00', '2016-02-01 00:00:00', 'base', 'base', 'base', 'base', 'base', '-1', NULL);"
echo 11
apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
