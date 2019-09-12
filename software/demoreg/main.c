#include "omsp_de1soc.h"

#define REG1   (*(volatile unsigned      *) 0x110)
#define REG2   (*(volatile unsigned char *) 0x112)
#define REG3   (*(volatile unsigned char *) 0x115)

int main(void) {
  de1soc_init();

  while (1) {
    REG1 = 0x1234;
    REG2 = 0x56;
    REG3 = 0x78;

    de1soc_hexhi(1);
    de1soc_hexlo(REG1);
    long_delay(2000);

    de1soc_hexhi(2);
    de1soc_hexlo(REG2);
    long_delay(2000);
    
    de1soc_hexhi(3);
    de1soc_hexlo(REG3);
    long_delay(2000);    
  }
  LPM0;

  return 0;
}
