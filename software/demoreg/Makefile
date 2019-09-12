# base
MSPBASE=/cygdrive/c/ti/msp430-gcc/bin
# configuration
MSPCC=${MSPBASE}/msp430-elf-gcc
# MSPCCFLAGS=-Wall -Os -fdata-sections -ffunction-sections -mmcu=msp430c1111 
# MSPLDFLAGS=-mmcu=msp430c1111 -Wl,--gc-sections -minrt -T linker.x 
MSPCCFLAGS=-Wall -Os -mmcu=msp430c1111 -Ic:/ti/msp430-gcc/include 
MSPLDFLAGS=-mmcu=msp430c1111 -T linker.x 
MSPOBJCOPY=${MSPBASE}/msp430-elf-objcopy
MSPOBJDUMP=${MSPBASE}/msp430-elf-objdump
MSPSIZE=${MSPBASE}/msp430-elf-size

all:
	@echo "Targets: "
	@echo "  compile    Compile software packages"
	@echo "  clean      Remove intermediate files"

compile: demoreg.bin

main.o: main.c
	$(MSPCC)  -I../hal $(MSPCCFLAGS) -c $< -o $@ 
	$(MSPSIZE) $@

demoreg.elf: main.o
	$(MSPCC)  $(MSPLDFLAGS) -L../hal  $< -lomsp_de -o $@ 
	$(MSPSIZE) $@
	${MSPOBJDUMP} -dSt demoreg.elf >demoreg.lst

demoreg.bin: demoreg.elf
	$(MSPOBJCOPY) -I elf32-msp430 -O binary demoreg.elf demoreg.bin

clean:
	rm -rf demoreg.elf *.o *~ demoreg.bin demoreg.lst

