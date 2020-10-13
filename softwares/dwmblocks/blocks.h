//Modify this file to change what commands output to your statusbar, and recompile using the make command.
# define PATH(name)		"~/.local/share/dwmblocksscripts/"name

static const Block blocks[] = {
	/*Icon*/	/*Command*/				/*Update Interval*/	/*Update Signal*/
	{"",		"echo",					0,					1}, /* a blank space for aesthetics */
	{"",		PATH("disk"),			60,					1},
	{"",		PATH("cpu"),			5,					1},
	{"",		PATH("battery"),		60,					1},
	{"",		PATH("date"),			60,					1},
	{"",		PATH("clock"),			60,					1},
	{"",		PATH("internet"),		5,					1},
	{"",		"echo",					0,					1}, /* a blank space for aesthetics */
};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = "  ";
static unsigned int delimLen = 5;
