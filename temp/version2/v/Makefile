INCLUDE= defines.vh
SRC= ascii2int.v binary_to_bcd.v hostaddress.v ram_fix.v received_msg_processor.v session_manager.v create_message.v fsm_msg_create_2.v sequence_generator.v connection_toe.v create_checksum.v fix_parser.v fix_parser_out_module.v checksum.v fix_engine.v bodylength.v interface_controller_in.v
BENCH= bench.v  
#BENCH= dut.sv
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
	./$(DUMP)> log.txt
view:
	dve -full64 -vpd vcdplus.vpd &

gtkwave:
	vcs -vpd2vcd vcdplus.vpd waveform.vcd
	gtkwave waveform.vcd &

wave:
	vcs -vpd2vcd vcdplus.vpd dut.vcd
	gtkwave dut.vcd &

clean:
	rm -rf csrc *.exe.daidir *.exe *.log *.inf .leda_work *.key *.vpd *.vcd DVEfiles simv*
	rm -rf testbench*
	
