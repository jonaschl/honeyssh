#!/bin/bash
apt-get update -y &&  DEBIAN_FRONTEND=noninteractive apt-get install -y -y mariadb-server
mysqld_safe & mysqladmin --silent --wait=30 ping || exit 1
#/usr/sbin/mysqld_safe &&  sleep 5
#mysqladmin --silent --wait=30 ping || exit 1
echo 1
mysql -e "GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;"
echo 2
mysql -u root -e "CREATE USER 'honeyssh'@'%' IDENTIFIED BY 'c4dH4T24Na';"
echo 3
mysql -u root -e "GRANT USAGE ON *.* TO 'honeyssh'@'%' IDENTIFIED BY 'c4dH4T24Na' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;"
echo 4
mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`honeyssh\`;"
echo 5
mysql -u root -e "GRANT ALL PRIVILEGES ON \`honeyssh\`.* TO 'honeyssh'@'%';"
echo 6
mysql -u root -e "show databases"
echo 7
#mysql -u root -e use honeyssh;
mysql -u honeyssh -pc4dH4T24Na -D honeyssh -e "CREATE TABLE \`login\` (\`session-id\` bigint(20) unsigned NOT NULL, \`number\` int(11) NOT NULL, \`time\` datetime NOT NULL, \`user\` text NOT NULL, \`password\` text NOT NULL, \`action\` int(11) NOT NULL, \`id\` bigint(20) NOT NULL AUTO_INCREMENT, PRIMARY KEY (\`id\`)) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;"
echo 8
mysql -u honeyssh -pc4dH4T24Na -D honeyssh -e "CREATE TABLE \`command\` (\`session-id\` bigint(20) unsigned NOT NULL, \`number\` int(11) NOT NULL, \`time\` datetime NOT NULL, \`command\` text NOT NULL, \`action\` int(11) NOT NULL, \`id\` int(11) NOT NULL AUTO_INCREMENT, PRIMARY KEY (\`id\`)) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;"
echo 9
mysql -u honeyssh -pc4dH4T24Na -D honeyssh -e "CREATE TABLE \`connection\` (\`session-id\` bigint(20) unsigned NOT NULL, \`ip\` text NOT NULL, \`start-time\` datetime NOT NULL, \`end-time\` datetime NOT NULL, \`banner\` text NOT NULL, \`cipher-in\` text NOT NULL, \`cipher-out\` text NOT NULL, \`protocol-version\` text NOT NULL, \`openssh-version\` text NOT NULL, \`action\` int(11) NOT NULL, \`id\` bigint(11) NOT NULL AUTO_INCREMENT,  PRIMARY KEY (\`id\`)) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;"
echo 10
apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

