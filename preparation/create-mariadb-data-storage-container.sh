docker run  -d --name honeyssh-mariadbdata -v /etc/mysql -v /var/lib/mysql jonatanschlag/honeyssh-mariadb:latest
sleep 5
docker stop honeyssh-mariadbdata
