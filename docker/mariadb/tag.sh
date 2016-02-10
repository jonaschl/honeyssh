#!/bin/bash
errorlevel=0
# check if we get a username
if [ -z "$1" ] || [ -z "$2" ]; then
#set the errorlevel to 1, because we have no username
errorlevel=1
else
username=$1
repo=$2
date=$(date +%Y-%m-%d)
patternrep="$username/${repo}"
patterntag="$date"
# get id of the image from today
back=$(./get-id.sh $patternrep $patterntag)
set $back
id=$1
backerrorlevel=$2
	# check if the get-id script finish with errorlevel 0
	if [ "$backerrorlevel" = "0" ] ; then
		# the id is empty the creaetd images is the first image today 
				if [ "$id" = "empty" ] ; then
				# get the id from the new image
				patternrep="$username/${repo}"
				patterntag="new"
				back=$(./get-id.sh $patternrep $patterntag)
				set $back
				id=$1
				backerrorlevel=$2
				# check if the get-id script finish with errorlevel 0
				if [ "$backerrorlevel" = "0" ] ; then
					# rmi the tag latest
					docker rmi "$username/${repo}:latest"
					# tag the new image with the date from today and latest
					docker tag "$id" "$username/${repo}:latest"
					docker tag "$id" "$username/${repo}:$date"
					# rmi the tag new
					docker rmi "$username/${repo}:new"
				else
					#set errorlevel to 1, because the call of the get id script in line 23 do not finish with errorlevel=0
					errorlevel=1
				fi
		else
		# the id is != empty it exist a image build today in this repo
		patternrep="$username/${repo}"
		patterntag="new"
		back=$(./get-id.sh $patternrep $patterntag)
		set $back
		id=$1
		backerrorlevel=$2
		# check if the get-id script finish with errorlevel 0
			if [ "$backerrorlevel" = "0" ] ; then
				# rmi the image with the tag latest and $date
				docker rmi "$username/${repo}:latest"
				docker rmi "$username/${repo}:$date"
				#tag the new image with latest and date
				docker tag "$id" "$username/${repo}:latest"
				docker tag "$id" "$username/${repo}:$date"
				# rmi the tag new
				docker rmi "$username/${repo}:new"
			else
				#set errorlevel to 1, because the call of the get id script in line 43 do not finish with errorlevel=0
				errorlevel=1
			fi
		fi
	else
	#set errorlevel to 1, because the call of the get id script in line 12 do not finish with errorlevel=0
	errorlevel=1
	fi
fi
#echo errorlevel
echo $errorlevel

