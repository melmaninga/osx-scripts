#!/bin/bash
# This script is performs one the essential setup steps for newly enrolled computers.
# These steps apply to factory fresh, re-imaged, or reallocated computers
# Ideally this should be called by a cached policy

################################# Set Variables ######################################

# Name of admin account which should be installed on the computer
timeZone="Australia/Melbourne"
timeServer=""

######################################################################################

# Use Active Directory Domain for Time Server if bound
if [ "$(dsconfigad -show | grep "Active Directory Domain")" ] && [ -z "$timeServer" ]
	then
		timeServer=$(dsconfigad -show | awk -F "= " '/Active Directory Domain/ { print$2 }')
		echo "Setup Steps - Domain detected, time server set to $timeServer √"
	else
		echo "Setup Steps - Time server set to $timeServer √"		
fi

# Set Time Zone
if ! /usr/sbin/systemsetup -gettimezone | grep -q "$timeZone" ; then
	echo "TimeZone incorrectly set - changing to $timeZone"
	/usr/sbin/systemsetup -settimezone "$timeZone"
	/usr/bin/killall SystemUIServer
else
	echo "Setup Steps - Timezone $timeZone √"
fi

# Set Time Server
if  [ "$(/usr/sbin/systemsetup -getnetworktimeserver | awk '{print $4}')" != "$timeServer" ] ||  /usr/sbin/systemsetup -getusingnetworktime | grep -q "Off" ; then
	echo "TimeServer incorrectly set - changing to $timeServer"
	/usr/sbin/systemsetup -setnetworktimeserver $timeServer
	/usr/sbin/systemsetup -setusingnetworktime on 
else
	echo "Setup Steps - TimeServer $timeServer √"
fi
