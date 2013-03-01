#FILES=../src/fix_parser.sv ../src/fix_parser_out_module.sv ../src/fix_parser_top.sv ../src/tag_ram.sv ../src/value_ram.sv ../src/fifo.sv ../src/tag_fifo_top.sv ../src/value_fifo_top.sv
FILES=../src/fix_parser.sv ../src/fix_parser_out_module.sv ../src/fix_parser_top.sv ../src/cam/FF.sv ../src/cam/decoder.sv ../src/cam/priorityencoder.sv ../src/cam/camreg.sv ../src/cam/cam.sv ../src/cam_cntrl.sv ../src/value_ram.sv ../src/message_loc.sv ../src/message_loc_cntrl.sv ../src/read_message_cntrl.sv
TEST= dut
BENCH=../sim/testbench.exe

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

