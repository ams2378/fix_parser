#SRC=fsm_msg_create_2.v session_controller.v create_message.v configure.v top.v
SRC=session_manager.v
BENCH= session_manager_dut.v
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

clean:
	rm -rf csrc *.exe.daidir *.exe *.log *.inf .leda_work *.key *.vpd *.vcd DVEfiles
	rm -rf ../sim/testbench*

