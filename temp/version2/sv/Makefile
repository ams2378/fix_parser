INCLUDE= defines.vh
<<<<<<< HEAD
SRC= ascii2int.sv binary_to_bcd.sv hostaddress.sv ram.sv received_msg_processor.sv session_manager.sv create_message.sv fsm_msg_create_2.sv counter.sv sequence_generator.sv connection_toe.sv create_checksum.sv fix_parser.sv fix_parser_out_module.sv checksum.sv fix_engine.sv hbcounter.sv bodylength.sv interface_controller_in.sv end_to_end_system.sv
=======
SRC= ascii2int.sv binary_to_bcd.sv hostaddress.sv ram_fix.sv received_msg_processor.sv session_manager.sv create_message.sv fsm_msg_create_2.sv counter.sv sequence_generator.sv connection_toe.sv create_checksum.sv fix_parser.sv fix_parser_out_module.sv checksum.sv fix_engine.sv bodylength.sv interface_controller_in.sv
>>>>>>> f83c563eb82b7b51e483b1d7ea09393642d0a2ce
BENCH= bench.v  
#BENCH= dut.v
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
	
