#!/bin/bash
docker run -d -p 22:2222  -v=/opt/securehoney/logs:/opt/securehoney/logs jonatanschlag/honeyssh-pot:new /opt/securehoney/sshpot

