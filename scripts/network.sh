#!/bin/sh
## Network 🛜 ##

# This script calls configuration menu for nmtui or bluetooth if installed

if which bluetuith; then
	actions.sh network
else
	$TERMINAL --app-id=floating --title=nmtui -e nmtui ||
		$TERMINAL -e nmtui
fi
