#include "omsp_de1soc.h"

unsigned long wrap = 0;
void __attribute__ ((interrupt(TIMERA1_VECTOR))) timerisr (void) {
  if (TAIV == 0xA)
    wrap++;
}
  
unsigned count   = 0;
unsigned long TimerLap() {
  unsigned long lap;
  TACTL &= ~(MC1 | MC0); // stop timer
  TACTL &= ~(TAIE);      // disable further IRQ
  if (TAR < count)
    lap = (unsigned) (TAR - count) + ((wrap - 1) << 16);
  else
    lap = (unsigned) (TAR - count) + (wrap << 16);
  wrap = 0;
  count = TAR;
  TACTL |= TAIE; // reenable IRQ
  TACTL |= MC1;  // reenable timer
  return lap;
}

int main(void) {
  unsigned long k;
  volatile int c;
  volatile long i;
  
  TACTL  |= (TASSEL1 | MC1 | TACLR | TAIE);
  de1soc_init();

  _enable_interrupts();
  while (1) {
    TimerLap();
    //    for (i=0; i<1860; i++) c = c + 1;
    k = TimerLap();
    de1soc_hexhi(k >> 16); // hi word
    de1soc_hexlo(k );      // lo word
    long_delay(500);
  }
  _disable_interrupts();
  LPM0;  

  return 0;
}
