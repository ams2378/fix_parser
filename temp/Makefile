SRC=fsm_msg_create_2.v
BENCH= dut.v
DUMP=testbench.exe

all: 
	make clean
	make bench 
	make gtkwave
src:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(SRC) -o $(DUMP)
	./$(DUMP)

bench:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(SRC)  $(BENCH) -o $(DUMP)
	./$(DUMP)

view:
	dve -full64 -vpd vcdplus.vpd &

gtkwave:
	vcs -vpd2vcd vcdplus.vpd waveform.vcd
	gtkwave waveform.vcd &

#leda:
#	leda -full64 -sverilog -top $(DUV) $(DUV4).sv $(DUV42).sv $(DUV16).sv $(DUV41).sv $(DUV43).sv $(DUV).sv

clean:
	rm -rf csrc *.exe.daidir *.exe *.log *.inf .leda_work *.key *.vpd *.vcd DVEfiles
	rm -rf ../sim/testbench*

