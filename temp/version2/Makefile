INCLUDE= defines.vh
SRC=hostaddress.v ram.v received_msg_processor.v session_manager.v create_message.v fsm_msg_create_2.v counter.v sequence_generator.v

all: 
	make src  
src1:
	vlog $(INCLUDE) $(SRC)

src2:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(INCLUDE) $(SRC)

clean:
	rm -rf work
