all:
	@echo "Targets: "
	@echo "  compile    Compile software packages"
	@echo "  clean      Remove intermediate files"

clean:
	cd hal;         make clean; cd ..
	cd demode0nano; make clean; cd ..
	cd demode1soc;  make clean; cd ..
	cd timerperf1;  make clean; cd ..
	cd timerperf2;  make clean; cd ..
	cd demoreg;     make clean; cd ..
	cd demo2reg;    make clean; cd ..

compile:
	cd hal;         make compile; cd ..
	cd demode0nano; make compile; cd ..
	cd demode1soc;  make compile; cd ..
	cd timerperf1;  make compile; cd ..
	cd timerperf2;  make compile; cd ..
	cd demoreg;     make compile; cd ..
	cd demo2reg;    make compile; cd ..
