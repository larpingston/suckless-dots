#!/bin/sh

# -- settings
outdir="$HOME/vids"
fps=30
crf=18
preset=ultrafast
abitrate=128k
# notifications
msg_start="started"
msg_pause="paused"
msg_resume="resumed"
msg_stop="saved"
msg_already="already recording"
msg_nothing="not recording"
# dmenu
dmenu_fn="Hack:size=12"
dmenu_nb="#222222"
dmenu_nf="#eeeeee"
dmenu_sb="#252525"
dmenu_sf="#a09e9e"
dmenu_lines=5
# files
pidfile=/tmp/rec.pid
pausefile=/tmp/rec.paused
outfile=/tmp/rec.out
# -- end of settings

dmenu_opts="-fn $dmenu_fn -nb $dmenu_nb -nf $dmenu_nf -sb $dmenu_sb -sf $dmenu_sf -l $dmenu_lines"
mkdir -p "$outdir"

notify() { notify-send "rec" "$1"; }

if [ -f "$pausefile" ]; then
	status="paused:"
	choices="continue\nstop"
elif [ -f "$pidfile" ]; then
	status="recording:"
	choices="start\npause\nstop"
else
	status="not recording:"
	choices="start\npause\nstop"
fi

choice=$(printf "$choices" | dmenu $dmenu_opts -p "$status") || exit 0

case "$choice" in
	start)
		[ -f "$pidfile" ] && { notify "$msg_already"; exit 1; }
		res=$(xrandr | awk '/\*/{print $1; exit}')
		sink=$(pactl get-default-sink).monitor
		f="$outdir/rec_$(date +%Y-%m-%d_%H-%M-%S).mp4"
		echo "$f" > "$outfile"
		ffmpeg -f x11grab -framerate "$fps" -video_size "$res" -i "$DISPLAY" \
			-f pulse -i "$sink" \
			-c:v libx264 -preset "$preset" -crf "$crf" -pix_fmt yuv420p \
			-c:a aac -b:a "$abitrate" \
			"$f" > /tmp/rec.log 2>&1 &
		echo $! > "$pidfile"
		notify "$msg_start → $(basename "$f")"
		;;
	pause)
		[ -f "$pidfile" ] || { notify "$msg_nothing"; exit 1; }
		kill -STOP "$(cat "$pidfile")"
		touch "$pausefile"
		notify "$msg_pause"
		;;
	continue)
		[ -f "$pausefile" ] || { notify "not paused"; exit 1; }
		kill -CONT "$(cat "$pidfile")"
		rm -f "$pausefile"
		notify "$msg_resume"
		;;
	stop)
		[ -f "$pidfile" ] || { notify "$msg_nothing"; exit 1; }
		[ -f "$pausefile" ] && { kill -CONT "$(cat "$pidfile")"; rm -f "$pausefile"; }
		kill -INT "$(cat "$pidfile")"
		rm -f "$pidfile"
		notify "$msg_stop → $(basename "$(cat "$outfile")")"
		rm -f "$outfile"
		;;
esac
