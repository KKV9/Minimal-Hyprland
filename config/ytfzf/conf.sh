external_menu() {
	#use rofi instead of dmenu
	fuzzel -d -w 110 -p "$1"
}
video_player() {
	setsid -f mpv "$@" >/dev/null 2>&1
}
audio_player() {
	setsid -f mpv --no-video "$@" >/dev/null 2>&1
}
