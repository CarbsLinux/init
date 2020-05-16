// shalt -- simple halt utility
#include <sys/reboot.h>

int main (int argc, char *argv[]) {
    switch ((int)argv[argc < 2 ? 0 : 1][0]) {
    case 'p': reboot(RB_POWER_OFF); break;
    case 'r': reboot(RB_AUTOBOOT); break;
    default: return 1;
    }; return 0;
}
