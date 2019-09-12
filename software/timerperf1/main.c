#include "omsp_de1soc.h"

char c16[]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};

void puthex(unsigned k) {
  putchar(c16[((k>>12) & 0xF)]);
  putchar(c16[((k>>8 ) & 0xF)]);
  putchar(c16[((k>>4 ) & 0xF)]);
  putchar(c16[((k    ) & 0xF)]);
}

unsigned count = 0;

unsigned TimerLap() {
  unsigned lap;
  TACTL &= ~(MC1 | MC0);
  lap = TAR - count;
  count = TAR;
  TACTL |= MC1;
  return lap;
}

int main(void) {
  int k;
  volatile int c;
  
  TACTL  |= (TASSEL1 | MC1 | TACLR);
  de1soc_init();

  while (1) {
    TimerLap();
    c = c + 1;
    c = c + 1;
    k = TimerLap();
    de1soc_hexlo(k);
      long_delay(100);
  }
  LPM0;  

  return 0;
}
