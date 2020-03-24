#include <unistd.h>
#include <sys/reboot.h>

/* Simple halt utility                                        */
/* Reboot if the argument is r, Poweroff is the argument is p */

int main (int argc, char *argv[]) {
    switch ((int)argv[argc < 2 ? 0 : 1][0] + geteuid()) {
    case 'p': reboot(RB_POWER_OFF); break;
    case 'r': reboot(RB_AUTOBOOT); break;
    default: return 1;
    }; return 0;
}
