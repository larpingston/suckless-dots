/* blocks.h - edit this file, then: make && sudo make install, restart dwmblocks
 *
 * format: { "prefix", "command", interval_seconds, signal }
 * interval 0 = only refresh on signal
 * to force refresh: kill -RTMIN+<signal> $(pidof dwmblocks)
 */

static const Block blocks[] = {
	/* volume */
	{ "   ", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf \"[ vol 󰕾 %d%% ]\", $2 * 100}'", 1, 0 },

	/* cpu usage */
	{ "", "awk '/^cpu / {usage=($2+$4)*100/($2+$4+$5); printf \"[ cpu 󰍛 %d%% ]\", usage}' /proc/stat", 2, 0 },

	/* ram used */
	{ "", "free -h | awk '/^Mem/ {printf \"[ ram 󰘚 %s ]\", $3}' | sed 's/i//g'", 5, 0 },

	/* date + time, 12h with AM/PM */
	{ "", "date '+%a %b %d %I:%M %p '", 1, 0 },
};

/* separator between blocks */
static char delim[] = "  ";
static unsigned int delimLen = 3;
