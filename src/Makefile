FILES=fix_parser_out_module.sv fix_parser.sv fix_parser_top.sv

TEST= dut
BENCH=testbench.exe

all: 
	make clean
	make test
	make gtkwave
duv4:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(FILES) -o $(BENCH)
	./$(BENCH)

test:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(FILES)  $(TEST).sv -o $(BENCH)
	./$(BENCH)

view:
	dve -full64 -vpd vcdplus.vpd &

gtkwave:
	vcs -vpd2vcd vcdplus.vpd waveform.vcd
	gtkwave waveform.vcd &

#leda:
#	leda -full64 -sverilog -top $(DUV) $(DUV4).sv $(DUV42).sv $(DUV16).sv $(DUV41).sv $(DUV43).sv $(DUV).sv
clean:
	rm -rf csrc *.exe.daidir *.exe *.log *.inf .leda_work *.key *.vpd *.vcd DVEfiles



#duv41:
#	vcs -full64 -PP -sverilog +define+SV +define+VPD $(DUV41).sv -o $(BENCH)
#	./$(BENCH)
#duv:
#	vcs -full64 -PP -sverilog +define+SV +define+VPD $(DUV4).sv $(DUV41).sv $(DUV).sv -o $(BENCH)
#	./$(BENCH)

