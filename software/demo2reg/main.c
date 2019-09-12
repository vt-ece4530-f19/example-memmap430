#include "omsp_de1soc.h"

#define SEC    (*(volatile unsigned char *) 0x116)
unsigned long wrap = 0;

void __attribute__ ((interrupt(2))) demo2regisr (void) {
  de1soc_hexlo(SEC);
}

int main(void) {
  de1soc_init();

  _enable_interrupts();
  while (1) ;

  _disable_interrupts();
  return 0;
}
