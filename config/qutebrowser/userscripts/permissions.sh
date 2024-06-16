#!/bin/sh
## Permissions ⛔ ##

# This userscript makes lists of urls to be loaded by config.py
# Example: allowing sites access to clipboard or cookies

# Error checking
if [ -z "$1" ] || ! [ -w "$QUTE_CONFIG_DIR/permissions/$2" ]; then
	echo "message-error 'Incorrect command usage!'" >"$QUTE_FIFO"
	exit 1
fi

# Toggle url in permissions file
if grep "$1" "$QUTE_CONFIG_DIR"/permissions/"$2"; then
	grep -v "$1" "$QUTE_CONFIG_DIR"/permissions/"$2" > \
		"$QUTE_CONFIG_DIR"/permissions/"$2".tmp &&
		mv "$QUTE_CONFIG_DIR"/permissions/"$2".tmp "$QUTE_CONFIG_DIR"/permissions/"$2" &&
		echo "message-info '$1 removed from $2 permissions list'" \
			>"$QUTE_FIFO" ||
		echo "message-error 'failed to remove $1 from $2 allowed list'" \
			>"$QUTE_FIFO"
else
	echo "$1" >>"$QUTE_CONFIG_DIR"/permissions/"$2" &&
		echo "message-info '$1 added to $2 allowed list!'" \
			>"$QUTE_FIFO" ||
		echo "message-error 'failed to add $1 to $2 allowed list'" \
			>"$QUTE_FIFO"
fi
