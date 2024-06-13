#!/bin/sh
## Volume 🔊##

# Volume controls for audio and mic

VOLUME_LIMIT="1.0" # Max volume increase
MIC_LIMIT="1.0"    # Max mic level increase

# Get Volume
get_volume() {
	volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ |
		cut -c 9- |
		sed -e 's/\.//' -e 's/^0*//')
	if [ -z "$volume" ]; then
		echo "0%"
	else
		echo "$volume%"
	fi
}

# Get icons
get_icon() {
	volume=$(get_volume)
	if [ "${volume%?}" -le 30 ]; then
		echo "audio-volume-low"
	elif [ "${volume%?}" -le 60 ]; then
		echo "audio-volume-medium"
	else
		echo "audio-volume-high"
	fi
}

# Notify
notify_volume() {
	if get_volume | grep -e "MUTED"; then
		notify-send -e -h string:x-canonical-private-synchronous:volume_notif \
			-u low -i "audio-off" "Volume: Muted"
	else
		notify-send -e -h int:value:"$(get_volume)" \
			-h string:x-canonical-private-synchronous:volume_notif \
			-u low -i "$(get_icon)" "Volume: $(get_volume)"
	fi
	pw-play /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga
}

# Increase Volume
inc_volume() {
	if get_volume | grep -e "MUTED"; then
		toggle_mute
	else
		wpctl set-volume -l "$VOLUME_LIMIT" @DEFAULT_AUDIO_SINK@ 5%+ && notify_volume
	fi
}

# Decrease Volume
dec_volume() {
	if get_volume | grep -e "MUTED"; then
		toggle_mute
	else
		wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify_volume
	fi
}

# Toggle Mute
toggle_mute() {
	wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify_volume
}

# Get mic volume
get_mic_volume() {
	volume=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ |
		cut -c 9- |
		sed -e 's/\.//' -e 's/^0*//')
	if [ -z "$volume" ]; then
		echo "0%"
	else
		echo "$volume%"
	fi
}

# Notify for Microphone
notify_mic_volume() {
	if get_mic_volume | grep -e "MUTED"; then
		notify-send -e -h "string:x-canonical-private-synchronous:volume_notif" \
			-u low -i "audio-input-microphone-muted" "Microphone: Muted"
	else
		notify-send -e -h int:value:"$(get_mic_volume)" \
			-h "string:x-canonical-private-synchronous:volume_notif" \
			-u low -i "mic-on" "Microphone: $(get_mic_volume)"
	fi
}

# Increase MIC Volume
inc_mic_volume() {
	if get_mic_volume | grep -e "MUTED"; then
		toggle_mic
	else
		wpctl set-volume -l "$MIC_LIMIT" @DEFAULT_AUDIO_SOURCE@ 5%+ && notify_mic_volume
	fi
}

# Decrease MIC Volume
dec_mic_volume() {
	if get_mic_volume | grep -e "MUTED"; then
		toggle-mic
	else
		wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%- && notify_mic_volume
	fi
}

# Toggle Mic
toggle_mic() {
	wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && notify_mic_volume
}

# Execute accordingly
if [ "$1" = "--inc" ]; then
	inc_volume
elif [ "$1" = "--dec" ]; then
	dec_volume
elif [ "$1" = "--toggle" ]; then
	toggle_mute
elif [ "$1" = "--toggle-mic" ]; then
	toggle_mic
elif [ "$1" = "--inc-mic" ]; then
	inc_mic_volume
elif [ "$1" = "--dec-mic" ]; then
	dec_mic_volume
else
	get_volume
fi
