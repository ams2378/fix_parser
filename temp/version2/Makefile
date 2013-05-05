INCLUDE= defines.vh
SRC= ascii2int.sv binary_to_bcd.sv hostaddress.sv ram.sv rece.sved_msg_processor.sv session_manager.sv create_message.sv fsm_msg_create_2.sv counter.sv sequence_generator.sv connection_toe.sv create_checksum.sv fix_parser.sv fix_parser_out_module.sv checksum.sv fix_engine.sv bodylength.sv interface_controller_in.sv
BENCH= dut.sv
DUMP= testbench.exe

test:
	make clean
	make src2
	make gtkwave 

all: 
	make src1
	make src2  
src1:
	vlog $(INCLUDE) $(SRC) 
#$(BENCH)

src2:
	vcs -full64 -PP -sverilog +vcs+loopreport[+200] +define+SV +define+VPD $(INCLUDE) $(SRC) $(BENCH) -o $(DUMP)
	./$(DUMP)
view:
	dve -full64 -vpd vcdplus.vpd &

gtkwave:
	vcs -vpd2vcd vcdplus.vpd waveform.vcd
	gtkwave waveform.vcd &

clean:
	rm -rf csrc *.exe.daidir *.exe *.log *.inf .leda_work *.key *.vpd *.vcd DVEfiles simv*
	rm -rf testbench*
	
