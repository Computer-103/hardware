#include <stdlib.h>
#include <stdio.h>

unsigned mem[2048];
int init[2048];

int main() {
    int T = 1000000;
    while (T--) {
        unsigned addr = rand() % 04000;
        unsigned data = rand() & 0x7fffffff;
        unsigned wen = rand() % 2;
        unsigned ren = !wen;
        if (!init[addr]) {
            wen = 1;
            ren = 0;
        }
        if (ren) {
            data = mem[addr];
        } else if (wen) {
            mem[addr] = data;
            init[addr] = 1;
        }
        printf("%04o %011o %d %d\n", addr, data, wen, ren);
    }
    return 0;
}