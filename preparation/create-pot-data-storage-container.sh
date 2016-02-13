docker run  -d --name honeyssh-potdata -v=/opt/securehoney/logs  jonatanschlag/honeyssh-pot:latest
sleep 5
docker stop honeyssh-potdata
