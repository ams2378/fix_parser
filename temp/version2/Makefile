INCLUDE= defines.vh
SRC= bin2bcd/binary_to_bcd.v hostaddress.v ram.v received_msg_processor.v session_manager.v create_message.v fsm_msg_create_2.v counter.v sequence_generator.v connection_toe.v create_checksum.v fix_parser.v fix_parser_out_module.v checksum.v fix_engine.v

all: 
	make src1
	make src2  
src1:
	vlog $(INCLUDE) $(SRC)

src2:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(INCLUDE) $(SRC)

clean:
	rm -rf work
