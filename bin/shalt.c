/* shalt -- simple halt utility */
#define _XOPEN_SOURCE 500

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/reboot.h>

static char *argv0;
#include "arg.h"

static void
usage(void)
{
	fprintf(stderr, "usage: %s [-pr]\n", argv0);
	exit(1);
}

int
main(int argc, char *argv[])
{
	sync();

	ARGBEGIN {
		case 'p':
			reboot(RB_POWER_OFF);
			break;
		case 'r':
			reboot(RB_AUTOBOOT);
			break;
		default:
			usage();
	} ARGEND

	if (argc != 2) usage();
	return 0;
}
