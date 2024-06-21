#!/bin/sh
## Battery 🔋 ##

# Low battery notifications

# Find battery directory
BAT=$(find /sys/class/power_supply/BAT* | head -n 1)

# If no battery is found, exit
if ! [ -d "$BAT" ]; then
	exit 0
fi

while true; do
	# Sleep for 2 minutes
	sleep 120

	# Get battery level and state
	level="$(cat "$BAT"/capacity)"
	status="$(cat "$BAT"/status)"

	# If charging reset last notification
	if [ "$status" = "Charging" ]; then
		last_notification=""
		sleep 600 # 10 minute sleep
		continue
	fi

	# Check for critical battery level
	if [ "$level" -le 5 ] && [ "$last_notification" != "critical" ]; then
		notify-send -u critical -i "battery-empty" \
			"Battery notify" "Battery level critical ($level%)"
		last_notification="critical"
		sleep 600 # 10 minute sleep
		continue
	fi

	# Check for low battery level
	if [ "$level" -le 20 ] && [ -z "$last_notification" ]; then
		notify-send -u normal -i "battery-caution" \
			"Battery notify" "Battery level low ($level%)"
		last_notification="low"
	fi
done
