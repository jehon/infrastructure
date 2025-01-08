#!/usr/bin/sh

#
# Load common profiles
#

if [ -d /etc/jehon/profile.d ]; then
	for i in /etc/jehon/profile.d/*.sh; do
		if [ -r $i ]; then
			. $i
		fi
	done
	unset i
fi
