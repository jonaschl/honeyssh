#!/bin/bash

#set some variables
repo="honeyssh-mysql"
dockertag="new2"

if [ -z $1 ] ; then
errorlevel=1
else
username=$1
tag="${username}/${repo}:${dockertag}"
docker build --no-cache=true -t "$tag" .
errorlevel=$?
echo $errorlevel
fi
