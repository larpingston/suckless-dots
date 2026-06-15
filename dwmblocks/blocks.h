/* blocks.h - edit this file, then: make && sudo make install, restart dwmblocks
 *
 * format: { "prefix", "command", interval_seconds, signal }
 * interval 0 = only refresh on signal
 * to force refresh: kill -RTMIN+<signal> $(pidof dwmblocks)
 */

static const Block blocks[] = {
	/* keyboard layout — signal 1 to refresh */
	{ "  ", "setxkbmap -query | awk '/layout/ {print \"[ \" toupper($2) \" ]\"}'", 0, 1 },

	/* weather — change "Gori,Georgia" to your city */
	{ "", "curl -sf 'wttr.in/Gori,Georgia?format=%t' | tr -d '+' | awk '{print \"[ \" $0 \" ]\"}'", 1800, 0 },

	/* volume */
	{ "", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf \"[ vol %d%% ]\", $2 * 100}'", 1, 0 },

	/* cpu usage */
	{ "", "vmstat 1 2 | tail -1 | awk '{printf \"[ cpu %d%% ]\", 100-$15}'", 2, 0 },

	/* ram used */
	{ "", "free -h | awk '/^Mem/ {printf \"[ ram %s ]\", $3}' | sed 's/i//g'", 5, 0 },

	/* date — man date for format options */
	{ "", "date '+[ %a %d %b ]'", 60, 0 },

	/* clock — use %I:%M for 12h */
	{ "", "date '+[ %H:%M ]'", 60, 0 },
};

/* separator between blocks — delimLen must be strlen(delim) + 1 */
static char delim[] = "  ";
static unsigned int delimLen = 3;
