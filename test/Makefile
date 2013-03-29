MODULES= dut.sv fileio.sv
TEST=dut.sv 
BENCH=testbench.exe

all: 
	make clean
	make test
	make run
	make gtkwave
test:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(MODULES) -o $(BENCH)
#	./$(BENCH)

view:
	dve -full64 -vpd vcdplus.vpd &

run:
	./$(BENCH)

gtkwave:
	vcs -vpd2vcd vcdplus.vpd waveform.vcd
	gtkwave waveform.vcd &

#leda:
#	leda -full64 -sverilog -top $(DUV) $(DUV4).sv $(DUV42).sv $(DUV16).sv $(DUV41).sv $(DUV43).sv $(DUV).sv
clean:
	rm -rf csrc *.exe.daidir *.exe *.log *.inf .leda_work *.key *.vpd *.vcd DVEfiles testbench.exe* 
	rm -rf log* power* key* 



#duv41:
#	vcs -full64 -PP -sverilog +define+SV +define+VPD $(DUV41).sv -o $(BENCH)
#	./$(BENCH)
#duv:
#	vcs -full64 -PP -sverilog +define+SV +define+VPD $(DUV4).sv $(DUV41).sv $(DUV).sv -o $(BENCH)
#	./$(BENCH)

