#!/bin/bash
###
### get id function
###
function getid()
{
shopt -s extglob
# we need a repo name and a tag
if [ -z $1 ] || [ -z $2 ] ; then
errorlevel=1
else
patternrep=$1
patterntag=$2
id=empty
linenumber=2
docker images > /tmp/images-docker.txt
linequantity=$(sed $= -n /tmp/images-docker.txt)
while [[ "$linenumber" -le "$linequantity" ]]
do
cline=$(sed -n "${linenumber} p" /tmp/images-docker.txt)
cline=${cline//+(  )/;}
cline=${cline%;}

if [[ "$cline" = *"$patternrep"* && "$cline" = *"$patterntag"* ]]
then
cline=${cline%;*}
cline=${cline%;*}
cline=${cline#*;}
cline=${cline#*;}
id=$cline
fi
linenumber=$(( linenumber + 1 ))
#echo $linequantity
#echo $linenumber
done
errorlevel=$?
fi
echo $id $errorlevel
}

###
### Build the Base Dockerimage (Debian Jessie)
###

### check if we have the buildscript and check if the script is up to date
if [ -d "$HOME/docker/contrib" ] ; then
# the script exist execute update
(cd "$HOME/docker" || exit
git pull)
else
# the script does not exist get it from github
(cd "$HOME" || exit
git clone https://github.com/docker/docker.git)
fi

### paramter for base build
repo="honeyssh-base"
dockertag="new"
username="jonatanschlag"
date=$(date +%Y-%m-%d)
# remove any aexisting build directorys to have a clean environment 
rm -d -f -r "/tmp/build-debian-jessie-armv7-$date"
# create the build directory
mkdir -p "/tmp/build-debian-jessie-armv7-$date"
(cd "$HOME/docker/contrib" || exit
#create the dockerfile
./mkimage.sh -d "/tmp/build-debian-jessie-armv7-$date"  debootstrap --variant=minbase --include=inetutils-ping,iproute2 --components=main   jessie http://ftp.halifax.rwth-aachen.de/debian/)
( cd "/tmp/build-debian-jessie-armv7-$date" || exit
# build the base image
tag="${username}/${repo}:${dockertag}"
docker build --no-cache=true -t "$tag" .)
# cleanup
rm -f -r -d /tmp/build-debian-jessie-armv7-$date/

### tag the new image
date=$(date +%Y-%m-%d)
patternrep="$username/${repo}"
patterntag="$date"
### get id of the image from today
back=$(getid $patternrep $patterntag)
set $back
id=$1
backerrorlevel=$2
### check if the getid script finish with errorlevel 0
if [ "$backerrorlevel" = "0" ] ; then
  # the id is empty
      if [ "$id" = "empty" ] ; then
      # get the id from the new image
      patternrep="$username/${repo}"
      patterntag="new"
      back=$(getid $patternrep $patterntag)
      set $back
      id=$1
      backerrorlevel=$2
      # check if the getid script finish with errorlevel 0
        if [ "$backerrorlevel" = "0" ] ; then
          # rmi the tag latest
          docker rmi "$username/$repo:latest"
          # tag the new immage with the date from today and latest
          docker tag "$id" "$username/$repo:latest"
          docker tag "$id" "$username/$repo:$date"
          # rmi the tag new
          docker rmi "$username/$repo:new"
        else
          #set errorlevel to 1, because the call of the get id function in line 23 do not finish with errorlevel=0
          echo "tagging was not successful"
        fi
      else
      # the id is != empty
      patternrep="$username/${repo}"
      patterntag="new"
      back=$(getid.sh $patternrep $patterntag)
      set $back
      id=$1
      backerrorlevel=$2
      # check if the getid script finish with errorlevel 0
        if [ "$backerrorlevel" = "0" ] ; then
          # rmi the image with the tag latest and $date
          docker rmi "$username/$repo:latest"
          docker rmi "$username/$repo:$date"
          #tag the new image with latest and date
          docker tag "$id" "$username/$repo:latest"
          docker tag "$id" "$username/$repo:$date"
          # rmi the tag new
          docker rmi "$username/$repo:new"
        else
          #set errorlevel to 1, because the call of the get id script in line 43 do not finish with errorlevel=0
          echo "tagging was not successful"
        fi
      fi
else
  echo "tagging was not successful"
fi

###
### Generate a password (we use this spassowrd to secure the mysql database)
###

password=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 30 | xargs)
echo -e ""
echo -e "\033[31mGenerated password is:\033[0m"
echo -e "\033[31m${password}\033[0m"
echo -e ""
###
### Build the MariaDB Dockerimage
###
( cd "mariadb" || exit
#create a work copy of setup.sh
cp setup-org.sh setup.sh
# insert the password into setup.sh
sed -i s/"rpassword"/"${password}"/g setup.sh
### paramter for mariadb build
repo="honeyssh-mariadb"
dockertag="new"
username=jonatanschlag
tag="${username}/${repo}:${dockertag}"
### Build the docker image
docker build --no-cache=true -t "$tag" .
### tag the new mariadb image
date=$(date +%Y-%m-%d)
patternrep="$username/${repo}"
patterntag="$date"
### get id of the image from today
back=$(getid $patternrep $patterntag)
set $back
id=$1
backerrorlevel=$2
### check if the getid script finish with errorlevel 0
if [ "$backerrorlevel" = "0" ] ; then
  # the id is empty
      if [ "$id" = "empty" ] ; then
      # get the id from the new image
      patternrep="$username/${repo}"
      patterntag="new"
      back=$(getid $patternrep $patterntag)
      set $back
      id=$1
      backerrorlevel=$2
      # check if the getid script finish with errorlevel 0
        if [ "$backerrorlevel" = "0" ] ; then
          # rmi the tag latest
          docker rmi "$username/$repo:latest"
          # tag the new immage with the date from today and latest
          docker tag "$id" "$username/$repo:latest"
          docker tag "$id" "$username/$repo:$date"
          # rmi the tag new
          docker rmi "$username/$repo:new"
        else
          #set errorlevel to 1, because the call of the get id function in line 23 do not finish with errorlevel=0
          echo "tagging was not successful"
        fi
      else
      # the id is != empty
      patternrep="$username/${repo}"
      patterntag="new"
      back=$(getid $patternrep $patterntag)
      set $back
      id=$1
      backerrorlevel=$2
      # check if the getid script finish with errorlevel 0
        if [ "$backerrorlevel" = "0" ] ; then
          # rmi the image with the tag latest and $date
          docker rmi "$username/$repo:latest"
          docker rmi "$username/$repo:$date"
          #tag the new image with latest and date
          docker tag "$id" "$username/$repo:latest"
          docker tag "$id" "$username/$repo:$date"
          # rmi the tag new
          docker rmi "$username/$repo:new"
        else
          #set errorlevel to 1, because the call of the get id script in line 43 do not finish with errorlevel=0
          echo "tagging was not successful"
        fi
      fi
else
  echo "tagging was not successful"
fi
rm -f setup.sh
)

###
### Build the Pot Dockerimage
###
( cd "pot" || exit
#create a work copy of setup.sh
cp setup-org.sh setup.sh
# insert the password into setup.sh
sed -i s/"rpassword"/"${password}"/g setup.sh
### paramter for pot build
repo="honeyssh-pot"
dockertag="new"
username=jonatanschlag
tag="${username}/${repo}:${dockertag}"
### Build the docker image
docker build --no-cache=true -t "$tag" .
### tag the new pot image
date=$(date +%Y-%m-%d)
patternrep="$username/${repo}"
patterntag="$date"
### get id of the image from today
back=$(getid $patternrep $patterntag)
set $back
id=$1
backerrorlevel=$2
### check if the getid script finish with errorlevel 0
if [ "$backerrorlevel" = "0" ] ; then
  # the id is empty
      if [ "$id" = "empty" ] ; then
      # get the id from the new image
      patternrep="$username/${repo}"
      patterntag="new"
      back=$(getid $patternrep $patterntag)
      set $back
      id=$1
      backerrorlevel=$2
      # check if the getid script finish with errorlevel 0
        if [ "$backerrorlevel" = "0" ] ; then
          # rmi the tag latest
          docker rmi "$username/$repo:latest"
          # tag the new immage with the date from today and latest
          docker tag "$id" "$username/$repo:latest"
          docker tag "$id" "$username/$repo:$date"
          # rmi the tag new
          docker rmi "$username/$repo:new"
        else
          #set errorlevel to 1, because the call of the get id function in line 23 do not finish with errorlevel=0
          echo "tagging was not successful"
        fi
      else
      # the id is != empty
      patternrep="$username/${repo}"
      patterntag="new"
      back=$(getid $patternrep $patterntag)
      set $back
      id=$1
      backerrorlevel=$2
      # check if the getid script finish with errorlevel 0
        if [ "$backerrorlevel" = "0" ] ; then
          # rmi the image with the tag latest and $date
          docker rmi "$username/$repo:latest"
          docker rmi "$username/$repo:$date"
          #tag the new image with latest and date
          docker tag "$id" "$username/$repo:latest"
          docker tag "$id" "$username/$repo:$date"
          # rmi the tag new
          docker rmi "$username/$repo:new"
        else
          #set errorlevel to 1, because the call of the get id script in line 43 do not finish with errorlevel=0
          echo "tagging was not successful"
        fi
      fi
else
  echo "tagging was not successful"
fi
rm -f setup.sh
)

