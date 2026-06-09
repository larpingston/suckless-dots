//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/						/*Update Interval*/	/*Update Signal*/

  {"   ", "uname -sr | awk '{print \"[ \" $0 \" ] \"}'",	0,	0},
   
	{"vol ", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf \"%d%%\", $2*100}'",	1,	0},

  {"cpu ", "vmstat 1 2 | tail -1 | awk '{print 100-$15\"%\"}'",	2,	0},

	{"ram ", "free -h | awk '/^Mem/ { print $3 }' | sed 's/i//g'",	1,	0},

  {"date ", "date '+[ %d %b %Y ] [ %H:%M ]'",	60,	0},
};

static char delim[] = "  |  ";
static unsigned int delimLen = 7;

